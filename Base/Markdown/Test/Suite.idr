module Test.Suite

import IdrTest.Test

import Test.Markdown.Format.HtmlTest
import Test.Markdown.LexerTest
import Test.MarkdownTest

suite : IO ()
suite = do
  runSuites
    [ Test.Markdown.LexerTest.suite
    , Test.MarkdownTest.suite
    , Test.Markdown.Format.HtmlTest.suite
    ]
