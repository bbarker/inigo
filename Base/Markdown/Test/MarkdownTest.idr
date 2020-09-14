module Test.MarkdownTest

import IdrTest.Test
import IdrTest.Expectation

import Markdown.Data
import Markdown

parserSpecs : List (String, String, Maybe Markdown)
parserSpecs =
  [ ( "Parse Header", "# test", Just $ Doc [Header 1 [Text " test"]] )
  , ( "Parse Short Paragraph", "test", Just $ Doc [Paragraph [Text "test"]] )
  , ( "Parse Paragraph", "test\n\n", Just $ Doc [Paragraph [Text "test"]] )
  , ( "Parse Two Paragraphs", "test\n\ntest2", Just $ Doc [Paragraph [Text "test"], Paragraph [Text "test2"]] )
  , ( "Parse Both", "# text\nand more\n\n", Just $ Doc [Header 1 [Text " text"], Paragraph [Text "and more"]] )
  , ( "Parse Bold then Italic", "## Well **hello** _there_", Just $ Doc [Header 2 [Text " Well ", Bold [Text "hello"], Text " ", Italics [Text "there"]]] )
  , ( "Parse a Link", "[here](http://example.com)", Just $ Doc [Paragraph [Link "here" "http://example.com"]] )
  , ( "Parse an Image", "![desc](http://example.com/img.svg)", Just $ Doc [Paragraph [Image "desc" "http://example.com/img.svg"]] )
  , ( "Parse HTML", "This is <sup>Super</sup>!", Just $ Doc [Paragraph [Text "This is ", Html "sup" [Text "Super"], Text "!"]] )
  , ( "Parse Non-HTML Brackets", "A < B > C <D E> >F< << >>", Just $ Doc [Paragraph [Text "A < B > C <D E> >F< << >>"]] )
  , ( "Parse Preformatted Text", "# Hello `john`\n```how\nare\nyou```", Just $ Doc [Header 1 [Text " Hello ", Pre "john"], Paragraph [CodeBlock "are\nyou" (Just "how")]] )
  , ( "Parse Spaced Start", "\n\n# test\n\n\n\n", Just $ Doc [Header 1 [Text " test"]] )
  ]

export
suite : Test
suite =
  let
    parserTests =
      map (\(name, text, result) =>
        test name (\_ => assertEq (parse text) result)
      ) parserSpecs
  in
  describe "Markdown"
    [ describe "Parser Specs" parserTests ]
