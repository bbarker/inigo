module Test.ColorTest

import IdrTest.Test
import IdrTest.Expectation

import Color

simpleTest : Test
simpleTest =
  test "Red & Bold" (\_ => assertEq
    (decorate (Text Red <&> BG Blue <&> Bold) "Hello")
    "\ESC[31m\ESC[44m\ESC[1mHello\ESC[0m\ESC[0m\ESC[0m"
  )

export
suite : Test
suite =
  describe "Color Tests"
    [ simpleTest
    ]
