module Inigo.Archive.Path

import Data.List
import Data.Strings
import Extra.String
import Inigo.Package.Package
import Inigo.Util.Path.Path

isIPkg : String -> Bool
isIPkg =
  isSuffixOf ".ipkg"

isBuild : String -> Bool
isBuild =
  isInfixOf "/build/"

isDep : String -> Bool
isDep =
  isInfixOf "/Deps/"

isDisallowed : String -> Bool
isDisallowed x =
  isIPkg x || isBuild x || isDep x

export
ignoreFiles : List String -> List String
ignoreFiles =
  filter (not . isDisallowed)

export
depPath : Package -> String
depPath pkg =
  let
    modPath = pathUnsplit (split '.' (package pkg))
  in
    joinPath "Deps" (joinPath (ns pkg) modPath)
