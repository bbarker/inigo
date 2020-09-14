module Test.Extra.ListTest

import IdrTest.Test
import IdrTest.Expectation

import Extra.List

export
suite : Test
suite =
  describe "List Extra Tests" [
    describe "Length" [
      test "Populated List" (\_ => assertEq
        (length [1,2,3])
        3
      ),
      test "Empty" (\_ => assertEq
        (length (the (List Int) []))
        0
      )
    ],
    describe "Range" [
      test "Simple Range" (\_ => assertEq
        (range 5)
        [0,1,2,3,4]
      ),
      test "Empty Range" (\_ => assertEq
        (range 0)
        []
      )
    ],
    describe "Zip with Index" [
      test "Simple List" (\_ => assertEq
        (zipWithIndex ['a', 'b', 'c', 'd'])
        [('a', 0), ('b', 1), ('c', 2), ('d', 3)]
      ),
      test "Empty List" (\_ => assertEq
        (zipWithIndex (the (List Int) []))
        []
      )
    ],
    describe "Find all" [
      test "Find all simple" (\_ => assertEq
        (findAll (unpack "abcbcd") (unpack "bc"))
        ([1, 3])
      )
    ],
    describe "Replace" [
      test "Replace simple" (\_ => assertEq
        (replace (unpack "abcbcd") (unpack "bc") (unpack "zzz"))
        (unpack "azzzzzzd")
      )
    ]
  ]
