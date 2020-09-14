module Extra.Monad

||| Function to sequence two functors
||| TODO: Can we do this with applicative instead of monad?
export
map2 : Monad m => (a -> b -> c) -> m a -> m b -> m c
map2 f x y =
  join $ map (\x' => map (\y' => f x' y') y) x

||| Function to sequence three functors
export
map3 : Monad m => (a -> b -> c -> d) -> m a -> m b -> m c -> m d
map3 f x y z =
  (map2 f x y) <*> z
