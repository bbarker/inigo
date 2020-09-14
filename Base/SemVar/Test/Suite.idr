module Test.Suite

import IdrTest.Test

import Test.SemVar.DataTest
import Test.SemVar.LexerTest
import Test.SemVar.ParserTest
import Test.SemVar.SatTest

suite : IO ()
suite = do
  runSuites
    [ Test.SemVar.LexerTest.suite
    , Test.SemVar.ParserTest.suite
    , Test.SemVar.DataTest.suite
    , Test.SemVar.SatTest.suite
    ]
