module Test.Extra.StringTest

import IdrTest.Test
import IdrTest.Expectation

import Extra.String

export
suite : Test
suite =
  describe "String Extra Tests"
    [ test "Replace String" (\_ => assertEq
        (replace "abba" "oodle" "My String Yabba Dabba")
        "My String Yoodle Doodle"
      ),
      test "Quote String" (\_ => assertEq
        (quote "my string\nis cool")
        "\"my string\\nis cool\""
      ),
      test "Unquote String" (\_ => assertEq
        (unquote "\"my string\\nis cool\"")
        "my string\nis cool"
      ),
      test "Limit Limited" (\_ => assertEq
        (limit 4 "this is cool")
        "this..."
      ),
      test "Limit Unlimited" (\_ => assertEq
        (limit 40 "this is cool")
        "this is cool"
      )
    ]
