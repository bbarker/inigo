module Client.Action.Build

import Data.List
import Data.Strings
import Inigo.Async.Base
import Inigo.Async.FS
import Inigo.Async.Promise
import Inigo.Package.CodeGen
import Inigo.Package.Package
import Inigo.Async.Package

-- TODO: Better handling of base paths
export
iPkgFile : String
iPkgFile = "Inigo.ipkg"

export
writeIPkgFile : Promise Package
writeIPkgFile =
  do
    pkg <- Inigo.Async.Package.currPackage
    -- TODO: Only build if not exists ?
    fs_writeFile iPkgFile (Package.Package.generateIPkg False pkg)
    pure pkg

export
runBuild : CodeGen -> Package -> Promise ()
runBuild codeGen pkg =
  do
    system "idris2" ["--build", iPkgFile, "--cg", toString codeGen] False True
    pure ()

export
build : CodeGen -> Promise ()
build codeGen =
  do
    pkg <- writeIPkgFile
    runBuild codeGen pkg
