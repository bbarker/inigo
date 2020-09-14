module Test.Suite

import IdrTest.Test

import Test.Toml.DataTest
import Test.Toml.LexerTest
import Test.TomlTest

suite : IO ()
suite = do
  runSuites
    [ Test.Toml.LexerTest.suite
    , Test.Toml.DataTest.suite
    , Test.TomlTest.suite
    ]
