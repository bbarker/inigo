module Color

public export
data Color : Type where
  Black : Color
  Red : Color
  Green : Color
  Yellow : Color
  Blue : Color
  Magenta : Color
  Cyan : Color
  White : Color

public export
data Decorator : Type where
  Reset : Decorator
  Text : Color -> Decorator
  BG : Color -> Decorator
  Bold : Decorator
  Underline : Decorator
  Reversed : Decorator
  Both : Decorator -> Decorator -> Decorator

export %inline
(<&>) : Decorator -> Decorator -> Decorator
(<&>) = Both
infixr 5 <&>

ctrl : String -> String
ctrl =
  strCons (chr 27)

export
init : Decorator -> String
init Reset = ctrl "[0m"
init Bold = ctrl "[1m"
init Underline = ctrl "[4m"
init Reversed = ctrl "[7m"
init (Text Black) = ctrl "[30m"
init (Text Red) = ctrl "[31m"
init (Text Green) = ctrl "[32m"
init (Text Yellow) = ctrl "[33m"
init (Text Blue) = ctrl "[34m"
init (Text Magenta) = ctrl "[35m"
init (Text Cyan) = ctrl "[36m"
init (Text White) = ctrl "[37m"
init (BG Black) = ctrl "[40m"
init (BG Red) = ctrl "[41m"
init (BG Green) = ctrl "[42m"
init (BG Yellow) = ctrl "[43m"
init (BG Blue) = ctrl "[44m"
init (BG Magenta) = ctrl "[45m"
init (BG Cyan) = ctrl "[46m"
init (BG White) = ctrl "[47m"
init (Both a b) = init a ++ init b

export
fin : Decorator -> String
fin Reset = ""
fin (Both a b) = fin a ++ fin b
fin _ = init Reset

export
decorate : Decorator -> String -> String
decorate d str = (init d) ++ str ++ (fin d)
