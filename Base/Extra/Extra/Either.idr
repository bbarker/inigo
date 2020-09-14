module Extra.Either

import Data.Maybe

export
mapError : (a -> c) -> Either a b -> Either c b
mapError f e = either (Left . f) (Right . id) e

export
expect : a -> Maybe b -> Either a b
expect left =
  (fromMaybe $ Left left) . (map Right)

export
flipEither : Either a b -> Either b a
flipEither (Left x) = Right x
flipEither (Right x) = Left x
