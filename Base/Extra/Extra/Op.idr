module Extra.Op

public export
(>>) : (a -> b) -> (b -> c) -> (a -> c)
(>>) f g = g . f
infixr 9 >>

public export
(|>) : a -> (a -> b) -> b
(|>) x f = f x
infixr 5 |>
