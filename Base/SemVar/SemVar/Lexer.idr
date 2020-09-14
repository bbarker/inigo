module SemVar.Lexer

import Text.Lexer
import Text.Token

import public SemVar.Tokens

%default total

private
semVarTokenMap : TokenMap SemVarToken
semVarTokenMap = toTokenMap $
  [ (is '~', Tilde)
  , (is '^', Caret)
  , (is '.', Dot)
  , (digits, Number)
  , (is '-', Hyphen)
  , (exact ">=", CmpGTE)
  , (exact "<=", CmpLTE)
  , (is '>', CmpGT)
  , (is '<', CmpLT)
  , (is '=', CmpEQ)
  , (exact "||", Pipe)
  , (is '+', Plus)
  , (some alphaNum, Text)
  , (is '*', Asterisk)
  , (spaces, Whitespace)
  ]

public export
lexSemVar : String -> Maybe (List SemVarToken)
lexSemVar str
  = case lex semVarTokenMap str of
         (tokens, _, _, "") => Just $ map TokenData.tok tokens
         _ => Nothing
