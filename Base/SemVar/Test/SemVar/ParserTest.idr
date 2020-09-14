module Test.SemVar.ParserTest

import IdrTest.Test
import IdrTest.Expectation

import SemVar
import SemVar.Data
import SemVar.Parser

versionSpecs : List (String, Maybe Version)
versionSpecs =
  [
    (
      "1.2.3-prerelease+commit",
      Just (MkVersion 1 2 3 (Just "prerelease") (Just "commit"))
    ),
    (
      "1.2.3",
      Just (MkVersion 1 2 3 Nothing Nothing)
    )
  ]

-- TODO: Build a lot more examples from https://devhints.io/semver
-- TODO: Cover wildcards and partial ranges
reqSpecs : List (String, Maybe Requirement)
reqSpecs =
  [
    (
      "~1.2.3",
      Just (
        AND
          (GTE $ MkVersion 1 2 3 Nothing Nothing)
          (LT $ MkVersion 1 3 0 Nothing Nothing)
      )
    ),
    (
      "^1.2.3",
      Just (
        AND
          (GTE $ MkVersion 1 2 3 Nothing Nothing)
          (LT $ MkVersion 2 0 0 Nothing Nothing)
      )
    ),
    (
      "^0.2.3",
      Just (
        AND
          (GTE $ MkVersion 0 2 3 Nothing Nothing)
          (LT $ MkVersion 0 3 0 Nothing Nothing)
      )
    ),
    (
      "^0.0.1",
      Just (
        EQ $ MkVersion 0 0 1 Nothing Nothing
      )
    ),
    (
      "^1.2",
      Just (
        AND
          (GTE $ MkVersion 1 2 0 Nothing Nothing)
          (LT $ MkVersion 2 0 0 Nothing Nothing)
      )
    ),
    (
      "~1.2",
      Just (
        AND
          (GTE $ MkVersion 1 2 0 Nothing Nothing)
          (LT $ MkVersion 1 3 0 Nothing Nothing)
      )
    ),
    (
      "^1",
      Just (
        AND
          (GTE $ MkVersion 1 0 0 Nothing Nothing)
          (LT $ MkVersion 2 0 0 Nothing Nothing)
      )
    ),
    -- (
    --   "~1",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 0 0 Nothing Nothing)
    --       (LT $ MkVersion 2 0 0 Nothing Nothing)
    --   )
    -- ),
    -- (
    --   "1.x",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 0 0 Nothing Nothing)
    --       (LT $ MkVersion 2 0 0 Nothing Nothing)
    --   )
    -- ),
    -- (
    --   "1",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 0 0 Nothing Nothing)
    --       (LT $ MkVersion 2 0 0 Nothing Nothing)
    --   )
    -- ),
    -- (
    --   "*",
    --   Just (
    --     GTE $ MkVersion 0 0 0 Nothing Nothing
    --   )
    -- ),
    -- (
    --   "x",
    --   Just (
    --     GTE $ MkVersion 0 0 0 Nothing Nothing
    --   )
    -- ),
    -- (
    --   "1.2.x",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 2 0 Nothing Nothing)
    --       (LT $ MkVersion 1 3 0 Nothing Nothing)
    --   )
    -- ),
    -- (
    --   ">= 1.2.x",
    --   Just (
    --     GTE $ MkVersion 1 2 0 Nothing Nothing
    --   )
    -- ),
    -- (
    --   "<= 2.x",
    --   Just (
    --     LT $ MkVersion 3 0 0 Nothing Nothing
    --   )
    -- ),
    -- (
    --   "~1.2.x",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 2 0 Nothing Nothing)
    --       (LT $ MkVersion 1 3 0 Nothing Nothing)
    --   )
    -- ),
    (
      "1.2.3",
      Just (
        EQ $ MkVersion 1 2 3 Nothing Nothing
      )
    ),
    (
      "=1.2.3",
      Just (
        EQ $ MkVersion 1 2 3 Nothing Nothing
      )
    ),
    (
      ">1.2.3",
      Just (
        GT $ MkVersion 1 2 3 Nothing Nothing
      )
    ),
    (
      "<1.2.3",
      Just (
        LT $ MkVersion 1 2 3 Nothing Nothing
      )
    ),
    (
      ">=1.2.3",
      Just (
        GTE $ MkVersion 1 2 3 Nothing Nothing
      )
    ),
    (
      "1.2.3 -  2.3.4",
      Just (
        AND
          (GTE $ MkVersion 1 2 3 Nothing Nothing)
          (LTE $ MkVersion 2 3 4 Nothing Nothing)
      )
    ),
    -- (
    --   "1.2.3 - 2.3",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 2 3 Nothing Nothing)
    --       (LT $ MkVersion 2 4 0 Nothing Nothing)
    --   )
    -- ),
    -- (
    --   "1.2.3 - 2",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 2 3 Nothing Nothing)
    --       (LT $ MkVersion 3 0 0 Nothing Nothing)
    --   )
    -- ),
    -- (
    --   "1.2 - 2.3.0",
    --   Just (
    --     AND
    --       (GTE $ MkVersion 1 2 0 Nothing Nothing)
    --       (LTE $ MkVersion 2 3 0 Nothing Nothing)
    --   )
    -- ),
    (
      ">=0.14 <16",
      Just (
        AND
          (GTE $ MkVersion 0 14 0 Nothing Nothing)
          (LT $ MkVersion 16 0 0 Nothing Nothing)
      )
    ),
    (
      "0.14.0 || 15.0.0",
      Just (
        OR
          (EQ $ MkVersion 0 14 0 Nothing Nothing)
          (EQ $ MkVersion 15 0 0 Nothing Nothing)
      )
    )
    -- (
    --   "0.14.x || 15.x.x",
    --   Just (
    --     OR
    --       (AND
    --         (GTE $ MkVersion 0 14 0 Nothing Nothing)
    --         (LT $ MkVersion 16 0 0 Nothing Nothing)
    --       )
    --       (AND
    --         (GTE $ MkVersion 0 14 0 Nothing Nothing)
    --         (LT $ MkVersion 16 0 0 Nothing Nothing)
    --       )
    --   )
    -- )
  ]

export
suite : Test
suite =
  let
    versionTests =
      map (\(text, result) =>
        test text (\_ => assertEq (parseVersion text) result)
      ) versionSpecs

    reqTests =
      map (\(text, result) =>
        test text (\_ => assertEq (parseRequirement text) result)
      ) reqSpecs
  in
    describe "Parser Tests"
      [ describe "Version Specs" versionTests
      , describe "Requirement Specs" reqTests
      ]
