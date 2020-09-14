
## IdrTest

IdrTest is a unit-test library for Idris2. Idris allows developers to write dependently-typed and provably correct code, but sometimes there's no substitute for a simple unit test.

For instance, consider: `reverse : List a -> List a`. A unit test can easily add some confidence this function runs correctly (at least in some cases). It would be better to write a function that codes the meaning of reverse in its types, but in lieu of that, a unit test is helpful.

## Getting Started

Add `Base.IdrTest=^0.0.1` to `Inigo.toml` and run `inigo prod fetch-deps`. You should add a directory `Test` and copy in the following skeleton to `Test/Suite.idr`:

```haskell
module Test.Suite

import IdrTest.Test

myTestSuite : Test
myTestSuite =
	describe "My Tests" [
		test "Simple Math" (\_ => assertEq (2+2) 4)
	]

suite : IO ()
suite = do
  runSuites
    [ myTestSuite
    ]
```

To run your tests, run:

```bash
inigo test
```

or you can run them directly via:

```
idris2 --find-ipkg Test/Suite.idr -x suite
```

## Expectations

Currently there are three expecatations:

```haskell
assertEq : Show a => Eq a => a -> a -> Expectation
```

`assertEq` will test that two things are the same and return an error if they are not.

```haskell
fail : String -> Expectation
```

```haskell
pass : Expectation
```

`pass` and `fail` will always pass or fail a test respectively. You can use these functions to build more complex behaviors in your tests.

## Limitations

These tests are not meant to replace building correctness into your dependently-typed program. They are simply meant as a helpful addition to your Idris tool-chain. Additionally, IO and foreign-function calls may be difficult to test with IdrTest.

## Contributing

Feel free to grow and expand IdrTest to add new expectations or better handling of tests or failures.

## License

This code is licensed under the MIT license. All contributors must release all code under this same license.
