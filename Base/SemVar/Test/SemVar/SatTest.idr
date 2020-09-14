module Test.SemVar.SatTest

import IdrTest.Test
import IdrTest.Expectation

import Data.List
import Data.Maybe
import Extra.List

import SemVar
import SemVar.Data
import SemVar.Parser
import SemVar.Sat

satSpecs : List (String, List (List String, (List (String, (List (List String, String))))), List (List String, String), Either String (List (List String, String)))
satSpecs =
  [
    (
      "Simple Dep Test",
      [ (["Dep1"],
          [ ("1.2.3", [(["Dep2"], "~3.0.0")])
          , ("1.2.4", [(["Dep2"], "~3.0.0")])
          , ("2.0.0", [(["Dep2"], "~3.1")])
          ]
        )
      , (["Dep2"],
          [ ("3.0.0", [])]
        )
      ],
      [ (["Dep1"], "^1.2.3")
      , (["Dep2"], "^3.0.0")
      ],
      Right [(["Dep1"], "1.2.3"), (["Dep2"], "3.0.0")]
    ),
    (
      "Simple Sub-Dep Test",
      [ (["Dep1"],
          [ ("1.2.3", [(["Dep2"], "~3.0.0")])
          , ("1.2.4", [(["Dep2"], "~3.0.0")])
          , ("2.0.0", [(["Dep2"], "~3.1")])
          ]
        )
      , (["Dep2"],
          [ ("3.0.0", [])]
        )
      ],
      [ (["Dep1"], "^1.2.3")
      ],
      Right [(["Dep1"], "1.2.3"), (["Dep2"], "3.0.0")]
    ),
    (
      "Simple Sub-Sub-Dep Test",
      [ (["Dep1"],
          [ ("1.2.3", [(["Dep2"], "~3.0.0")])
          , ("1.2.4", [(["Dep2"], "~3.0.0")])
          , ("2.0.0", [(["Dep2"], "~3.1")])
          ]
        )
      , (["Dep2"],
          [ ("3.0.0", [(["Dep3"], "=5.0.0")])]
        )
      , (["Dep3"],
          [ ("5.0.0", [])]
        )
      ],
      [ (["Dep1"], "^1.2.3")
      ],
      Right [(["Dep1"], "1.2.3"), (["Dep2"], "3.0.0"), (["Dep3"], "5.0.0")]
    ),
    -- This is where we can't just rely on head anymore
    (
      "More complex test where we force Dep2 and have to match Dep1",
      [ (["Dep1"],
          [ ("1.2.3", [(["Dep2"], "~3.0.0")])
          , ("1.2.4", [(["Dep2"], "~3.0.0")])
          , ("2.0.0", [(["Dep2"], "~3.1")])
          ]
        )
      , (["Dep2"],
          [ ("3.0.0", [])
          , ("3.1.0", [])
          ]
        )
      ],
      [ (["Dep1"], ">=0")
      , (["Dep2"], "=3.1.0")
      ],
      Right [(["Dep1"], "2.0.0"), (["Dep2"], "3.1.0")]
    ),
    (
      "Mutual constraints",
      [ (["Dep1"],
          [ ("1.2.3", [(["Dep2"], "~3.0.0")])
          , ("1.2.4", [(["Dep2"], "~3.0.0")])
          , ("2.0.0", [(["Dep2"], "~3.1")])
          ]
        )
      , (["Dep2"],
          [ ("3.0.0", [(["Dep1"], ">=0")])
          ]
        )
      ],
      [ (["Dep1"], ">=0")
      ],
      Right [(["Dep1"], "1.2.3"), (["Dep2"], "3.0.0")]
    ),
    (
      "Mutual incompatible constraints",
      [ (["Dep1"],
          [ ("1.0.0", [(["Dep2"], "=4.0.0")])
          , ("2.0.0", [(["Dep2"], "=3.0.0")])
          ]
        )
      , (["Dep2"],
          [ ("3.0.0", [(["Dep1"], "=1.0.0")])
          , ("4.0.0", [(["Dep1"], "=2.0.0")])
          ]
        )
      ],
      [ (["Dep1"], ">=0")
      ],
      Left "Package [\"Dep1\"] req =1.0.0 is incompatible"
    ),
    (
      "Simple Failing Dep",
      [ (["Dep1"],
          [ ("1.2.3", [(["Dep2"], "~3.0.0")])
          , ("1.2.4", [(["Dep2"], "~3.0.0")])
          , ("2.0.0", [(["Dep2"], "~3.1")])
          ]
        )
      , (["Dep2"],
          [ ("3.0.0", [])]
        )
      ],
      [ (["Dep1"], "^1.2.3")
      , (["Dep2"], "^4.0.0")
      ],
      Left "Cannot match [\"Dep2\"] req >=4.0.0 <5.0.0"
    )
  ]

mapSnd : (b -> c) -> List (a, b) -> List (a, c)
mapSnd f =
  map (\(x, y) => (x, f y))

liftTuple : (a, Maybe b) -> Maybe (a, b)
liftTuple (a, Just x) = Just (a, x)
liftTuple _ = Nothing

collapseEither : Either a (Maybe b) -> Maybe (Either a b)
collapseEither (Left x) = Just (Left x)
collapseEither (Right (Just y)) = Just (Right y)
collapseEither (Right Nothing) = Nothing

makeVersionNodes : List String -> List (String, List (List String, String)) -> Maybe (List (List String, Version, List (List String, Requirement)))
makeVersionNodes name versions =
  collapse $ map (mkVersion name) versions
  where
    mkVersion : List String -> (String, List (List String, String)) -> Maybe VersionNode
    mkVersion name (versionStr, reqStrList) =
      do
        version <- parseVersion versionStr
        reqs <- collapse $ map liftTuple $ mapSnd parseRequirement reqStrList
        pure (name, version, reqs)

||| TODO: Move to Extra
map2 : Monad m => (a -> b -> c) -> m a -> m b -> m c
map2 f x y =
  join $ map (\x' => map (\y' => f x' y') y) x

map3 : Monad m => (a -> b -> c -> d) -> m a -> m b -> m c -> m d
map3 f x y z =
  (map2 f x y) <*> z

compareBy : Ord b => (a -> b) -> (a -> a -> Ordering)
compareBy f =
  (\x, y => compare (f x) (f y))

export
suite : Test
suite =
  let
    satTests = map (\(name, versionSpec, reqSpec, expSpec) => 
      let
        mVersionNodes : Maybe (List VersionNode)
        mVersionNodes = foldl (\mAcc, (dep, versions) =>
            do
              acc <- mAcc
              x <- makeVersionNodes dep versions
              pure (x ++ acc)
          ) (the (Maybe (List VersionNode)) (Just [])) versionSpec

        mReqs : Maybe (List (List String, Requirement))
        mReqs = collapse $ map (\(dep, reqStr) => 
            map (\req => (dep, req)) $ parseRequirement reqStr
          ) reqSpec

        maybeParseDepReq : (List String, String) -> Maybe (List String, Version)
        maybeParseDepReq (dep, verStr) =
          map (\vers => (dep, vers)) $ parseVersion verStr

        mExp : Either String (Maybe (List (List String, Version)))
        mExp = map collapse (map (map maybeParseDepReq) expSpec)

        sort : Either String (List (List String, Version)) -> Either String (List (List String, Version))
        sort =
          map (sortBy (compareBy fst))
      in
        test name (\_ =>
          let
            t = map3 (\versionNodes, reqs, exp =>
              assertEq (sort $ satisfyAll versionNodes reqs) exp
              ) mVersionNodes mReqs (map sort $ collapseEither mExp)
            in
              fromMaybe (Just "Invalid set-up for test") t
        )
      ) satSpecs
  in
    describe "Sat Tests" satTests
