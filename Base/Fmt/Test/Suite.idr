module Test.Suite

import IdrTest.Test

import Test.FmtTest

suite : IO ()
suite = do
  runSuites
    [ Test.FmtTest.suite
    ]
