module Toml.Tokens

import public Text.Token

import Data.List
import Extra.String

public export
data TomlTokenKind
  = Keyword
  | Dot
  | StringLit
  | Number
  | Equals
  | LeftBracket
  | RightBracket
  | Comma
  | Comment
  | Whitespace

public export
Eq TomlTokenKind where
  Keyword == Keyword = True
  Dot == Dot = True
  StringLit == StringLit = True
  Number == Number = True
  Equals == Equals = True
  LeftBracket == LeftBracket = True
  RightBracket == RightBracket = True
  Comma == Comma = True
  Comment == Comment = True
  Whitespace == Whitespace = True
  _ == _ = False

public export
TomlToken : Type
TomlToken = Token TomlTokenKind

public export
TokenKind TomlTokenKind where
  TokType Keyword = String
  TokType Dot = ()
  TokType StringLit = String
  TokType Number = Int
  TokType Equals = ()
  TokType LeftBracket = ()
  TokType RightBracket = ()
  TokType Comma = ()
  TokType Comment = ()
  TokType Whitespace = ()

  tokValue Keyword str = str
  tokValue Dot x = ()
  tokValue StringLit str = unquote str
  tokValue Number x = cast x
  tokValue Equals x = ()
  tokValue LeftBracket x = ()
  tokValue RightBracket x = ()
  tokValue Comma x = ()
  tokValue Comment x = ()
  tokValue Whitespace x = ()

export
Show TomlToken where
  show (Tok Keyword x) = "Keyword " ++ (quote x)
  show (Tok Dot x) = "Dot " ++ (quote x)
  show (Tok StringLit str) = "StringLit " ++ (quote str)
  show (Tok Number x) = "Number " ++ (show x)
  show (Tok Equals x) = "Equals " ++ (quote x)
  show (Tok LeftBracket x) = "LeftBracket " ++ (quote x)
  show (Tok RightBracket x) = "RightBracket " ++ (quote x)
  show (Tok Comma x) = "Comma " ++ (quote x)
  show (Tok Comment x) = "Comment " ++ (quote x)
  show (Tok Whitespace x) = "Whitespace " ++ (quote x)

export
Eq TomlToken where
  (Tok Keyword x0) == (Tok Keyword x1) = x0 == x1
  (Tok Dot x0) == (Tok Dot x1) = True
  (Tok StringLit x0) == (Tok StringLit x1) = x0 == x1
  (Tok Number x0) == (Tok Number x1) = x0 == x1
  (Tok Equals x0) == (Tok Equals x1) = True
  (Tok LeftBracket x0) == (Tok LeftBracket x1) = True
  (Tok RightBracket x0) == (Tok RightBracket x1) = True
  (Tok Comma x0) == (Tok Comma x1) = True
  (Tok Comment x0) == (Tok Comment x1) = x0 == x1
  (Tok Whitespace x0) == (Tok Whitespace x1) = True
  _ == _ = False
