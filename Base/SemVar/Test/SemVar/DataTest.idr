module Test.SemVar.DataTest

import IdrTest.Test
import IdrTest.Expectation

import Data.List

import SemVar
import SemVar.Data
import SemVar.Parser

repeat : a -> Nat -> List a
repeat _ Z = []
repeat x (S n) = x :: repeat x n

satisfySpecs : List (String, List String, List String)
satisfySpecs =
  [
    (
      "~1.2.3",
      ["1.2.3", "1.2.99"],
      ["1.2.3-prerelease+commit", "1.3.0", "1.3.1"]
    ),
    (
      "^1.2.3",
      ["1.2.3", "1.3.99"],
      ["1.2.3-prerelease+commit", "2.0.0", "5.3.1"]
    )
  ]

export
suite : Test
suite =
  let
    satisfyTests =
      concat $ map (\(reqText, sat, unsat) =>
        let
          reqM = parseRequirement reqText
          satZ = zip sat (repeat True (length sat))
          unsatZ = zip unsat (repeat False (length unsat))
        in
          map (\(v, isSat) =>
            let
              verb = if isSat then " satisfies " else " does not satisfy "
              testName = v ++ verb ++ reqText
            in
              case (parseVersion v, reqM) of
                (Just version, Just req) =>
                  test testName (\_ => assertEq (desc isSat) (desc (satisfy req version)))
                _ =>
                  test testName (\_ => assertEq "Failed to parse test" "")
          )
          (satZ ++ unsatZ)
      ) satisfySpecs
  in
    describe "Data Tests"
      [ describe "Satisfy Specs" satisfyTests
      ]
  where
    desc : Bool -> String
    desc True = "sat"
    desc False = "unsat"
