module Test.Suite

import IdrTest.Test

import Test.ColorTest

suite : IO ()
suite = do
  runSuites
    [ Test.ColorTest.suite
    ]
