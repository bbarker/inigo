module Test.Suite

import IdrTest.Test

import Test.Extra.ListTest
import Test.Extra.StringTest

suite : IO ()
suite = do
  runSuites
    [ Test.Extra.ListTest.suite
    , Test.Extra.StringTest.suite
    ]
