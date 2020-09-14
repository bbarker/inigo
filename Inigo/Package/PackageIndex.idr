module Inigo.Package.PackageIndex

import Data.List
import Data.Maybe
import Extra.Either
import Extra.List
import Extra.String
import Inigo.Package.ParseHelpers
import Inigo.Package.Package
import SemVar
import Toml

||| Information about a package in the index
public export
record PackageMeta where
  constructor MkPackageMeta
  ns : String
  package : String
  description : Maybe String
  version : Version

public export
PackageIndex : Type
PackageIndex = List PackageMeta

public export
Show PackageMeta where
  show (MkPackageMeta ns package description version) =
    "MkPackageMeta{ns=" ++ ns ++ ",package=" ++ package ++ ",description=" ++ (show description) ++ ",version=" ++ show version ++ "}"

public export
Eq PackageMeta where
  (MkPackageMeta ns0 package0 description0 version0) == (MkPackageMeta ns1 package1 description1 version1) =
    ns0 == ns1 && package0 == package1 && description0 == description1 && version0 == version1

parsePackageMetaToml : Toml -> Either String PackageMeta
parsePackageMetaToml toml =
  do
    ns <- string ["ns"] toml
    package <- string ["package"] toml
    description <- maybe (string ["description"] toml)
    versionStr <- string ["version"] toml
    version <- expect ("Invalid version: " ++ versionStr) (parseVersion versionStr)
    pure $ MkPackageMeta ns package description version

parsePackageIndexToml : Toml -> Either String PackageIndex
parsePackageIndexToml toml =
  case get ["pkg"] toml of
    Just (ArrTab arr) =>
      map reverse (foldl parseIndex (Right []) arr)
    _ =>
      Left "invalid package index `pkg` key"
  where
    parseIndex : Either String PackageIndex -> Toml -> Either String PackageIndex
    parseIndex accE toml =
      do
        acc <- accE
        packageMeta <- parsePackageMetaToml toml
        pure $ (packageMeta :: acc)

export
parsePackageIndex : String -> Either String PackageIndex
parsePackageIndex pkgIndexToml =
  do
    toml <- expect "Failed to parse PackageIndex Toml" $ parseToml pkgIndexToml
    parsePackageIndexToml toml

export
toToml : PackageIndex -> Toml
toToml pkgIndex =
  [ (["pkg"], ArrTab $ map toTomlPkg pkgIndex) ]
  where
    toTomlPkg : PackageMeta -> Toml
    toTomlPkg pkgMeta =
      mapMaybe id
        [ Just (["ns"], Str (ns pkgMeta))
        , Just (["package"], Str (package pkgMeta))
        , map (\desc => (["description"], Str desc)) (description pkgMeta)
        , Just (["version"], Str (show . version $ pkgMeta))
        ]

export
searchPackageIndex : String -> PackageIndex -> PackageIndex
searchPackageIndex search index =
  filter (\x => searchMany (cleanup search) [package x, fromMaybe "" (description x)]) index
  where
    cleanup : String -> List Char
    cleanup =
      (map toLower) . unpack

    doSearch : String -> List Char -> Bool
    doSearch str lookup =
      findAll (cleanup str) lookup /= []

    searchMany : List Char -> List String -> Bool
    searchMany lookup [] = False
    searchMany lookup (x :: xs) = (doSearch x lookup) || (searchMany lookup xs)

||| Encode a package, for instance, after adding a new dep
export
encodePackageIndex : PackageIndex -> String
encodePackageIndex = encode . toToml

export
fromPackage : Package -> PackageMeta
fromPackage pkg =
  MkPackageMeta (ns pkg) (package pkg) (description pkg) (version pkg)

export
updatePackageMeta : PackageIndex -> Package -> PackageIndex
updatePackageMeta pkgIndex pkg =
  let
    meta = fromPackage pkg
    (found, res) = foldl (accumulate meta) (False, []) pkgIndex
  in
    if found then
      reverse res
    else
      reverse (meta :: res)
  where
    accumulate : PackageMeta -> (Bool, PackageIndex) -> PackageMeta -> (Bool, PackageIndex)
    accumulate meta (True, acc) el = (True, el :: acc)
    accumulate meta (False, acc) el =
      if ns el == ns pkg && package el == package pkg then
        (True, meta :: acc)
      else
        (False, el :: acc)
