module Test.Markdown.LexerTest

import IdrTest.Test
import IdrTest.Expectation

import Markdown.Lexer

lexerSpecs : List (String, String, Maybe (List MarkdownToken))
lexerSpecs =
  [
    (
      "Complex Example",
      "## My _Heading_\n\nThis is some [text](https://text.com) and it's **cool**.\n\nBut there's more and it's interesting.\n# There's other things, <sup>too</sup>.\nBut that's not for today!",
      Just $
      [ Tok HeadingSym "##"
      , Tok MdText " My "
      , Tok ItalicsSym ""
      , Tok MdText "Heading"
      , Tok ItalicsSym ""
      , Tok NewLine ""
      , Tok NewLine ""
      , Tok MdText "This is some "
      , Tok MdLink "[text](https://text.com)"
      , Tok MdText " and it's "
      , Tok BoldSym ""
      , Tok MdText "cool"
      , Tok BoldSym ""
      , Tok MdText "."
      , Tok NewLine ""
      , Tok NewLine ""
      , Tok MdText "But there's more and it's interesting."
      , Tok NewLine ""
      , Tok HeadingSym "#"
      , Tok MdText " There's other things, "
      , Tok HtmlOpenTag "<sup>"
      , Tok MdText "too"
      , Tok HtmlCloseTag "</sup>"
      , Tok MdText "."
      , Tok NewLine ""
      , Tok MdText "But that's not for today!"
      ]
    ),
    (
      "Brackets Example",
      "A < B > C <D E> >F< << >>",
      Just $
      [ Tok MdText "A < B > C <D E> >F< << >>"
      ]
    ),
    (
      "Preformatted Text",
      "# Hello `john`\n```how\nare\nyou```",
      Just $
      [ Tok HeadingSym "#"
      , Tok MdText " Hello "
      , Tok MdPre "`john`"
      , Tok NewLine ""
      , Tok MdCodeBlock "```how\nare\nyou```"
      ]
    )
  ]

export
suite : Test
suite =
  let
    lexerTests =
      map (\(name, text, result) =>
        test name (\_ => assertEq (lexMarkdown text) result)
      ) lexerSpecs
  in
    describe "Lexer Tests"
      [ describe "Lexer Specs" lexerTests
      , describe "tokValue Tests"
          [ test "Heading" (\_ => assertEq (value $ (Tok HeadingSym "##")) 2)
          , test "Text" (\_ => assertEq (value $ (Tok MdText "Hello")) "Hello")
          , test "NewLine" (\_ => assertEq (value $ (Tok NewLine "\n")) ())
          , test "ItalicsSym" (\_ => assertEq (value $ (Tok ItalicsSym "_")) ())
          , test "BoldSym" (\_ => assertEq (value $ (Tok BoldSym "**")) ())
          , test "Link" (\_ => assertEq (value $ (Tok MdLink "[cool](https://cool.com)")) ("cool", "https://cool.com"))
          , test "HtmlOpenTag" (\_ => assertEq (value $ (Tok HtmlOpenTag "<sup>")) "sup")
          , test "HtmlCloseTag" (\_ => assertEq (value $ (Tok HtmlCloseTag "</sup>")) "sup")
          ]
      ]
