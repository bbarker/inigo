module SemVar.Tokens

import public Text.Token

public export
data SemVarTokenKind
  = Tilde
  | Caret
  | Dot
  | Number
  | Hyphen
  | CmpGT
  | CmpLT
  | CmpEQ
  | CmpGTE
  | CmpLTE
  | Pipe
  | Plus
  | Text
  | Asterisk
  | Whitespace

public export
Eq SemVarTokenKind where
  (==) Tilde Tilde = True
  (==) Caret Caret = True
  (==) Dot Dot = True
  (==) Number Number = True
  (==) Hyphen Hyphen = True
  (==) CmpGT CmpGT = True
  (==) CmpLT CmpLT = True
  (==) CmpEQ CmpEQ = True
  (==) CmpGTE CmpGTE = True
  (==) CmpLTE CmpLTE = True
  (==) Pipe Pipe = True
  (==) Plus Plus = True
  (==) Text Text = True
  (==) Asterisk Asterisk = True
  (==) Whitespace Whitespace = True
  (==) _ _ = False

public export
SemVarToken : Type
SemVarToken = Token SemVarTokenKind

public export
TokenKind SemVarTokenKind where
  TokType Tilde = ()
  TokType Caret = ()
  TokType Dot = ()
  TokType Number = Int
  TokType Hyphen = ()
  TokType CmpGT = ()
  TokType CmpLT = ()
  TokType CmpEQ = ()
  TokType CmpGTE = ()
  TokType CmpLTE = ()
  TokType Pipe = ()
  TokType Plus = ()
  TokType Text = String
  TokType Asterisk = ()
  TokType Whitespace = ()

  tokValue Tilde x = ()
  tokValue Caret x = ()
  tokValue Dot x = ()
  tokValue Number x = cast x
  tokValue Hyphen x = ()
  tokValue CmpGT x = ()
  tokValue CmpLT x = ()
  tokValue CmpEQ x = ()
  tokValue CmpGTE x = ()
  tokValue CmpLTE x = ()
  tokValue Pipe x = ()
  tokValue Plus x = ()
  tokValue Text x = x
  tokValue Asterisk x = ()
  tokValue Whitespace x = ()

export
Show SemVarToken where
  show (Tok Tilde x) = "Tilde"
  show (Tok Caret x) = "Caret"
  show (Tok Dot x) = "Dot"
  show (Tok Number x) = "Number " ++ (show x)
  show (Tok Hyphen x) = "Hyphen"
  show (Tok CmpGT x) = "CmpGT"
  show (Tok CmpLT x) = "CmpLT"
  show (Tok CmpEQ x) = "CmpEQ"
  show (Tok CmpGTE x) = "CmpGTE"
  show (Tok CmpLTE x) = "CmpLTE"
  show (Tok Pipe x) = "Pipe"
  show (Tok Plus x) = "Plus"
  show (Tok Text x) = "Text " ++ x
  show (Tok Asterisk x) = "Asterisk"
  show (Tok Whitespace x) = "Whitespace"

export
Eq SemVarToken where
  (Tok Tilde x0) == (Tok Tilde x1) = True
  (Tok Caret x0) == (Tok Caret x1) = True
  (Tok Dot x0) == (Tok Dot x1) = True
  (Tok Number x0) == (Tok Number x1) = x0 == x1
  (Tok Hyphen x0) == (Tok Hyphen x1) = True
  (Tok CmpGT x0) == (Tok CmpGT x1) = True
  (Tok CmpLT x0) == (Tok CmpLT x1) = True
  (Tok CmpEQ x0) == (Tok CmpEQ x1) = True
  (Tok CmpGTE x0) == (Tok CmpGTE x1) = True
  (Tok CmpLTE x0) == (Tok CmpLTE x1) = True
  (Tok Pipe x0) == (Tok Pipe x1) = True
  (Tok Plus x0) == (Tok Plus x1) = True
  (Tok Text x0) == (Tok Text x1) = x0 == x1
  (Tok Asterisk x0) == (Tok Asterisk x1) = True
  (Tok Whitespace x0) == (Tok Whitespace x1) = True
  _ == _ = False
