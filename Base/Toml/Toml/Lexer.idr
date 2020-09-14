module Toml.Lexer

import Text.Lexer
import Text.Token

import public Toml.Tokens

%default total

stringLitSingle : Lexer
stringLitSingle = quote (is '\'') any

||| Recognise one or more characters that can comprise a keyword
||| /[A-Za-z0-9-_]+/
export
keyword : Lexer
keyword = some (pred (\x => isAlphaNum x || x == '-' || x == '_'))

tomlTokenMap : TokenMap TomlToken
tomlTokenMap = toTokenMap $
  [ (stringLit, StringLit)
  , (stringLitSingle, StringLit)
  , (digits, Number)
  , (keyword, Keyword)
  , (is '.', Dot)
  , (is '=', Equals)
  , (is '[', LeftBracket)
  , (is ']', RightBracket)
  , (is ',', Comma)
  , (is '#' <+> manyUntil newline any, Comment)
  , (spaces, Whitespace)
  ]

public export
lexToml : String -> Maybe (List TomlToken)
lexToml str
  = case lex tomlTokenMap str of
         (tokens, _, _, "") => Just $ map TokenData.tok tokens
         _ => Nothing
