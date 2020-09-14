module Test.FmtTest

import IdrTest.Test
import IdrTest.Expectation

import Fmt

simpleTest : Test
simpleTest =
  test "Simple test" (\_ => assertEq
    (fmt "Hello")
    "Hello"
  )

stringTest : Test
stringTest =
  test "String test" (\_ => assertEq
    (fmt "Hello %s" "world")
    "Hello world"
  )

intTest : Test
intTest =
  test "String test" (\_ => assertEq
    (fmt "Health %d" 99)
    "Health 99"
  )

mixedTest : Test
mixedTest =
  test "String test" (\_ => assertEq
    (fmt "Name %s Age %d" "Thomas" 50)
    "Name Thomas Age 50"
  )

export
suite : Test
suite =
  describe "Fmt Tests"
    [ simpleTest
    , stringTest
    , intTest
    , mixedTest
    ]
