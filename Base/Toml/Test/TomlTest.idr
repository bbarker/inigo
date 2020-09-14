module Test.TomlTest

import IdrTest.Test
import IdrTest.Expectation

import Toml

parseSpecs : List (String, Maybe Toml)
parseSpecs =
  [
    (
      "hello=\"world\"",
      Just [(["hello"], Str "world")]
    ),
    (
      "hello=\"wor\\nld\"",
      Just [(["hello"], Str "wor\nld")]
    ),
    (
      "count=55",
      Just [(["count"], Num 55)]
    ),
    (
      "count=[55, [66 ,\"dog\"]]",
      Just [(["count"], Lst [Num 55,Lst [Num 66, Str "dog"]])]
    ),
    (
      "count=[\n55, \n66 ,77\n]",
      Just [(["count"], Lst [Num 55, Num 66, Num 77])]
    ),
    (
      "[x]\ny=55",
      Just [(["x", "y"], Num 55)]
    ),
    (
      "[x-z]\ny=55",
      Just [(["x-z", "y"], Num 55)]
    ),
    (
      "5=55",
      Just [(["5"], Num 55)]
    ),
    (
      "[\"x.y\"]\n\"z.z\"=55",
      Just [(["x.y", "z.z"], Num 55)]
    ),
    (
      "[a]\nb=1\n[c]\nd=1\ne=1",
      Just [
        (["a", "b"], Num 1),
        (["c", "d"], Num 1),
        (["c", "e"], Num 1)
      ]
    ),
    (
      "[a]\nb=1\nc.d=2\n[e.f]\ng=3",
      Just [
        (["a", "b"], Num 1),
        (["a", "c", "d"], Num 2),
        (["e", "f", "g"], Num 3)
      ]
    ),
    (
      "[[a]]\nb=1\nc=2\nd.e=3\n[[a]]\nb=3\nc=4\n[a.d]\ne=5",
      Just [
        (["a"], ArrTab [
          [ (["b"], Num 1)
          , (["c"], Num 2)
          , (["d", "e"], Num 3)
          ],
          [ (["b"], Num 3)
          , (["c"], Num 4)
          , (["d", "e"], Num 5)
          ]
        ])
      ]
    ),
    (
      "[cool]
description=\"cool package\"
version=\"1.2.3\"
[funk]
description=\"funky package\"
version=\"10.0.0\"",
      Just [
        (["cool", "description"], Str "cool package"),
        (["cool", "version"], Str "1.2.3"),
        (["funk", "description"], Str "funky package"),
        (["funk", "version"], Str "10.0.0")
      ]
    )
  ]

encodeSpecs : List (Toml, String)
encodeSpecs =
  [
    (
      [(["hello"], Str "world")],
      "hello=\"world\""
    ),
    (
      [(["hello.world"], Str "cool")],
      "\"hello.world\"=\"cool\""
    ),
    (
      [(["hello=world"], Str "cool")],
      "\"hello=world\"=\"cool\""
    ),
    (
      [(["count"], Num 55)],
      "count=55"
    ),
    (
      [(["deep","count"], Num 55)],
      "deep.count=55"
    ),
    (
      [
        (["a"], ArrTab [
          [ (["b"], Num 1)
          , (["c"], Num 2)
          , (["d", "e"], Num 3)
          ],
          [ (["b"], Num 3)
          , (["c"], Num 4)
          , (["d", "e"], Num 5)
          ]
        ])
      ],
      "[[a]]\nb=1\nc=2\nd.e=3\n\n[[a]]\nb=3\nc=4\nd.e=5"
    )
  ]

getSpecs : List (Toml, List String, Maybe Value)
getSpecs =
  [
    (
      [(["hello"], Str "world")],
      ["hello"],
      Just (Str "world")
    ),
    (
      [(["count"], Num 55)],
      ["count"],
      Just (Num 55)
    ),
    (
      [(["count"], Num 55)],
      ["butter"],
      Nothing
    ),
    (
      [(["count"], Num 55)],
      ["count", "more"],
      Nothing
    ),
    (
      [(["count"], Num 55)],
      [],
      Nothing
    ),
    (
      [(["deep","count"], Num 55)],
      ["deep", "count"],
      Just (Num 55)
    )
  ]

export
suite : Test
suite =
  let
    parseTests =
      map (\(text, result) =>
        test text (\_ => assertEq (parseToml text) result)
      ) parseSpecs

    encodeTests =
      map (\(toml, exp) =>
        test exp (\_ => assertEq (encode toml) exp)
      ) encodeSpecs

    getTests =
      map (\(toml, keys, exp) =>
        test ("Getting " ++ show keys ++ " from " ++ show toml) (\_ => assertEq (get keys toml) exp)
      ) getSpecs
  in
    describe "Toml Tests"
      [ describe "Parser Specs" parseTests
      , describe "Encoder Specs" encodeTests
      , describe "Get Specs" getTests
      ]
