module IdrTest.Expectation

import Color

public export
Expectation : Type
Expectation = Maybe String

export
assertEq : Show a => Eq a => a -> a -> Expectation
assertEq a b =
  if a == b then
    Nothing
  else
    Just ("Failed expectation, expected " ++ (decorate (Text Green) (show a)) ++ "=" ++ (decorate (Text Red) (show b)))

export
pass : Expectation
pass =
  Nothing

export
fail : String -> Expectation
fail err =
  Just ("Failed expectation: " ++ (decorate (Text Red) err))
