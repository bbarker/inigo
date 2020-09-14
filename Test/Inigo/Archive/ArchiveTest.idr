module Test.Inigo.Archive.ArchiveTest

import IdrTest.Test
import IdrTest.Expectation

import Inigo.Archive.Archive

export
suite : Test
suite =
  describe "Encode" [
    test "Simple Encode" (\_ => assertEq
      (encode [(["a","b"], "bbb"), (["a","c"], "ccc")])
      "a.b=\"bbb\"\na.c=\"ccc\""
    ),
    test "Simple Decode" (\_ => assertEq
      (decode "a.b=\"bbb\"\na.c=\"ccc\"")
      (Just [(["a","b"], "bbb"), (["a","c"], "ccc")])
    )
  ]
