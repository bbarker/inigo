module Inigo.Package.PackageDeps

import Data.List
import Data.Maybe
import Extra.Debug as Debug
import Extra.Either
import Extra.List
import Extra.Op
import Extra.String
import Inigo.Package.ParseHelpers
import Inigo.Package.Package
import SemVar
import Toml
import Toml.Data

||| Information about a package in the index
public export
record PackageDep where
  constructor MkPackageDep
  deps : List (List String, Requirement)
  dev : List (List String, Requirement)

public export
PackageDeps : Type
PackageDeps = List (Version, PackageDep)

public export
PackageDepTree : Type
PackageDepTree = List (List String, PackageDeps)

public export
Show PackageDep where
  show (MkPackageDep deps devDeps) =
    "MkPackageDep{deps=" ++ (show deps) ++ ",dev=" ++ (show devDeps) ++ "}"

public export
Eq PackageDep where
  (MkPackageDep deps0 dev0) == (MkPackageDep deps1 dev1) =
    deps0 == deps1 && dev0 == dev1

||| Helper function to group Toml values by the first part of each key
groupByHead : List (List String, Value) -> List (String, List (List String, Value))
groupByHead toml =
  let
    sorted = sortBy (\(k0, _), (k1, _) => compare k0 k1) toml
    results = foldl accumulate [] sorted
  in
    reverse $ map (\(head, vals) => (head, reverse vals)) results
  where
    accumulate : List (String, List (List String, Value)) -> (List String, Value) -> List (String, List (List String, Value))
    accumulate acc ([], _) = acc -- Skip empty keys
    accumulate [] (hd :: rest, val) = [(hd, [(rest, val)])]
    accumulate ((accKey, accValues) :: accRest) (hd :: rest, val) =
      if accKey == hd then
        (accKey, (rest, val) :: accValues) :: accRest
      else
        (hd, [(rest, val)]) :: (accKey, accValues) :: accRest

parsePackageDepsToml : Toml -> Either String PackageDeps
parsePackageDepsToml toml =
  map reverse $ collapse $ map parsePackageDep (groupByHead toml)
  where
    parsePackageDepToml : Toml -> Either String PackageDep
    parsePackageDepToml toml =
      do
        deps <- parseDeps ["deps"] toml
        devDeps <- parseDeps ["dev"] toml
        pure $ MkPackageDep deps devDeps

    parsePackageDep : (String, List (List String, Value)) -> Either String (Version, PackageDep)
    parsePackageDep (versionStr, depToml) =
      do
        version <- expect ("Invalid version: " ++ versionStr) (parseVersion versionStr)
        packageDep <- parsePackageDepToml depToml
        pure (version, packageDep)

export
parsePackageDeps : String -> Either String PackageDeps
parsePackageDeps pkgDepsToml =
  do
    toml <- expect "Failed to parse PackageDeps Toml" $ parseToml pkgDepsToml
    parsePackageDepsToml toml

export
parsePackageDepTree : String -> Either String PackageDepTree
parsePackageDepTree pkgDepsToml =
  do
    toml <- expect "Failed to parse PackageDeps Toml" $ parseToml pkgDepsToml
    foldl accumulate (Right []) (groupByHead toml)
  where
    accumulate : Either String PackageDepTree -> (String, Toml) -> Either String PackageDepTree
    accumulate (Left err) _ = Left err -- persist error
    accumulate (Right acc) (pkg, toml) =
      map (\packageDep => (split '.' pkg, packageDep) :: acc) (parsePackageDepsToml toml)

export
toToml : PackageDeps -> Toml
toToml =
  concat . map (\(version, (MkPackageDep deps dev)) =>
    showAllDeps version deps dev
    )
  where
    showDep : List String -> (List String, Requirement) -> (List String, Value)
    showDep keyHead (pkg, req) = (keyHead ++ pkg, Str $ show req)

    showDeps : Version -> String -> List (List String, Requirement) -> List (List String, Value)
    showDeps version key = map (showDep [show version, key])

    showAllDeps : Version -> List (List String, Requirement) -> List (List String, Requirement) -> List (List String, Value)
    showAllDeps version deps dev =
      (showDeps version "deps" deps) ++ 
      (showDeps version "dev" dev)

||| Encode a package, for instance, after adding a new dep
export
encodePackageDeps : PackageDeps -> String
encodePackageDeps = encode . toToml

export
fromPackage : Package -> PackageDep
fromPackage pkg =
  MkPackageDep (deps pkg) (devDeps pkg)

export
updatePackageDep : PackageDeps -> Package -> PackageDeps
updatePackageDep pkgDeps pkg =
  let
    pkgVersion = version pkg
    pkgDep = (pkgVersion, fromPackage pkg)
  in
    case break ((== pkgVersion) . fst) pkgDeps of
      (r, []) =>
        r ++ [pkgDep]
      (r, _ :: rest) =>
        r ++ (pkgDep :: rest)
