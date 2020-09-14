module Test.Suite

import IdrTest.Test

import Test.Inigo.Account.AccountTest
import Test.Inigo.Archive.ArchiveTest
import Test.Inigo.Package.PackageDepsTest
import Test.Inigo.Package.PackageIndexTest
import Test.Inigo.Package.PackageTest
import Test.Server.Template.TemplateTest

suite : IO ()
suite = do
  runSuites
    [ Test.Inigo.Account.AccountTest.suite
    , Test.Inigo.Archive.ArchiveTest.suite
    , Test.Inigo.Package.PackageDepsTest.suite
    , Test.Inigo.Package.PackageIndexTest.suite
    , Test.Inigo.Package.PackageTest.suite
    , Test.Server.Template.TemplateTest.suite
    ]
