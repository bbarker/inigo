module Test.Toml.LexerTest

import IdrTest.Test
import IdrTest.Expectation

import Toml.Lexer

lexerSpecs : List (String, Maybe (List TomlToken))
lexerSpecs =
  [
    (
      "# This is a TOML document.\n\ntitle = \"TOML Example\"\n[owner]\nname = \"Tom Preston-Werner\"",
      Just $
      [ Tok Comment "# This is a TOML document."
      , Tok Whitespace "\n\n"
      , Tok Keyword "title"
      , Tok Whitespace " "
      , Tok Equals "="
      , Tok Whitespace " "
      , Tok StringLit "\"TOML Example\""
      , Tok Whitespace "\n"
      , Tok LeftBracket "["
      , Tok Keyword "owner"
      , Tok RightBracket "]"
      , Tok Whitespace "\n"
      , Tok Keyword "name"
      , Tok Whitespace " "
      , Tok Equals "="
      , Tok Whitespace " "
      , Tok StringLit "\"Tom Preston-Werner\""
      ]
    ),
    (
      "[a]\nb=1\nc.d=2\n[e.f]\ng=3",
      Just $
      [ Tok LeftBracket "["
      , Tok Keyword "a"
      , Tok RightBracket "]"
      , Tok Whitespace "\n"
      , Tok Keyword "b"
      , Tok Equals "="
      , Tok Number "1"
      , Tok Whitespace "\n"
      , Tok Keyword "c"
      , Tok Dot "."
      , Tok Keyword "d"
      , Tok Equals "="
      , Tok Number "2"
      , Tok Whitespace "\n"
      , Tok LeftBracket "["
      , Tok Keyword "e"
      , Tok Dot "."
      , Tok Keyword "f"
      , Tok RightBracket "]"
      , Tok Whitespace "\n"
      , Tok Keyword "g"
      , Tok Equals "="
      , Tok Number "3"
      ]
    ),
    (
      "[\"a.b\"]\n\"c.b\"=1",
      Just $
      [ Tok LeftBracket "["
      , Tok StringLit "\"a.b\""
      , Tok RightBracket "]"
      , Tok Whitespace "\n"
      , Tok StringLit "\"c.b\""
      , Tok Equals "="
      , Tok Number "1"
      ]
    )
  ]

export
suite : Test
suite =
  let
    lexerTests =
      map (\(text, result) =>
        test text (\_ => assertEq (lexToml text) result)
      ) lexerSpecs
  in
    describe "Toml Lexer Tests"
      [ describe "Lexer Specs" lexerTests
      ]
