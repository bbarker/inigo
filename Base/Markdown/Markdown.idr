module Markdown

import Markdown.Lexer
import Markdown.Parser

import public Markdown.Data

%default total

||| Parse a Markdown string
export
parse : String -> Maybe Markdown
parse x = parseMarkdown !(lexMarkdown x)
