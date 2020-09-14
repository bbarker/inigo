module Markdown.String

import Data.Nat
import Text.Lexer
import Text.Quantity

%default total

export
headingSym : Lexer
headingSym
  = some (is '#')

export
imageSym : Lexer
imageSym
  = is '!'

export
newLine : Lexer
newLine = is '\n'

export
italicsSym : Lexer
italicsSym = is '_'

export
boldSym : Lexer
boldSym =
  count (exactly 2) (is '*')

export
link : Lexer
link =
      surround (is '[') (is ']') any
  <+> surround (is '(') (is ')') any

||| Note: we currently don't allow attributes
||| To do so, we might need to move this from the lexer into the parser
export
htmlOpenTag : Lexer
htmlOpenTag =
  surround (is '<') (is '>') alphaNum

export
htmlCloseTag : Lexer
htmlCloseTag =
  surround (exact "</") (is '>') alphaNum

export
pre : Lexer
pre = quote (is '`') (non newline)

export
codeFence : Lexer
codeFence = quote (exact "```") any

-- Grab the next non-newline character (even if it's special, like a *),
-- and then consume non-special characters until we find another special marker.
export
text : Lexer
text = (isNot '\n') <+> manyUntil (oneOf "_*\n<>#[]()`") any
