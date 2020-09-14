module Test.SemVar.LexerTest

import IdrTest.Test
import IdrTest.Expectation

import SemVar.Lexer

lexerSpecs : List (String, Maybe (List SemVarToken))
lexerSpecs =
  [
    (
      "1.2.3-prerelease+commit",
      Just $
      [ Tok Number "1"
      , Tok Dot "."
      , Tok Number "2"
      , Tok Dot "."
      , Tok Number "3"
      , Tok Hyphen "-"
      , Tok Text "prerelease"
      , Tok Plus "+"
      , Tok Text "commit"
      ]
    ),
    (
      "~1.2.3",
      Just $
      [ Tok Tilde "~"
      , Tok Number "1"
      , Tok Dot "."
      , Tok Number "2"
      , Tok Dot "."
      , Tok Number "3"
      ]
    ),
    (
      "^1.22.3",
      Just $
      [ Tok Caret "^"
      , Tok Number "1"
      , Tok Dot "."
      , Tok Number "22"
      , Tok Dot "."
      , Tok Number "3"
      ]
    ),
    (
      "1.*",
      Just $
      [ Tok Number "1"
      , Tok Dot "."
      , Tok Asterisk "*"
      ]
    ),
    (
      ">=1",
      Just $
      [ Tok CmpGTE ">="
      , Tok Number "1"
      ]
    ),
    (
      "1.2.3 - 2.3",
      Just $
      [ Tok Number "1"
      , Tok Dot "."
      , Tok Number "2"
      , Tok Dot "."
      , Tok Number "3"
      , Tok Whitespace " "
      , Tok Hyphen ""
      , Tok Whitespace " "
      , Tok Number "2"
      , Tok Dot "."
      , Tok Number "3"
      ]
    ),
    (
      "1.2.3 || 2.3",
      Just $
      [ Tok Number "1"
      , Tok Dot "."
      , Tok Number "2"
      , Tok Dot "."
      , Tok Number "3"
      , Tok Whitespace " "
      , Tok Pipe "||"
      , Tok Whitespace " "
      , Tok Number "2"
      , Tok Dot "."
      , Tok Number "3"
      ]
    )
  ]

export
suite : Test
suite =
  let
    lexerTests =
      map (\(text, result) =>
        test text (\_ => assertEq (lexSemVar text) result)
      ) lexerSpecs
  in
    describe "Lexer Tests"
      [ describe "Lexer Specs" lexerTests
      ]
