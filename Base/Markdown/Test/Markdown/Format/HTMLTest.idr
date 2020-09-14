module Test.Markdown.Format.HtmlTest

import IdrTest.Test
import IdrTest.Expectation

import Markdown
import Markdown.Data
import Markdown.Format.Html

toHtmlSpecs : List (String, Markdown, String)
toHtmlSpecs =
  [ ( "Render Header", Doc [Header 1 [Text " test"]], "<h1> test</h1>" )
  , ( "Render Short Paragraph", Doc [Paragraph [Text "test"]], "<p>test</p>"  )
  , ( "Render Paragraph", Doc [Paragraph [Text "test"]], "<p>test</p>" )
  , ( "Render Two Paragraphs", Doc [Paragraph [Text "test"], Paragraph [Text "test2"]], "<p>test</p>\n<p>test2</p>" )
  , ( "Render Both", Doc [Header 1 [Text " text"], Paragraph [Text "and more"]], "<h1> text</h1>\n<p>and more</p>" )
  , ( "Render Bold then Italic", Doc [Header 2 [Text " Well ", Bold [Text "hello"], Text " ", Italics [Text "there"]]], "<h2> Well <strong>hello</strong> <em>there</em></h2>" )
  , ( "Render a Link", Doc [Paragraph [Link "here" "http://example.com"]], "<p><a href=\"http://example.com\">here</a></p>" )
  , ( "Render an Image", Doc [Paragraph [Image "desc" "http://example.com/img.svg"]], "<p><img src=\"http://example.com/img.svg\" alt=\"desc\"></img></p>" )
  , ( "Render HTML", Doc [Paragraph [Text "This is ", Html "sup" [Text "Super"], Text "!"]], "<p>This is <sup>Super</sup>!</p>" )
  , ( "Render Preformatted Text", Doc [Paragraph [Pre "t0", CodeBlock "t1 <cool>" Nothing]], "<p><tt>t0</tt><pre>t1 &lt;cool&gt;</pre></p>" )
  , ( "Render a Link with Space", Doc [Paragraph [Link "here" "http://example.com", Text "."]], "<p><a href=\"http://example.com\">here</a>.</p>" )
  ]

export
suite : Test
suite =
  let
    toHtmlTests =
      map (\(name, doc, result) =>
        test name (\_ => assertEq (toHtml doc) result)
      ) toHtmlSpecs
  in
  describe "toHTML Tests" toHtmlTests
