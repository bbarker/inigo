module Inigo.Package.ParseHelpers

import Toml

export
maybe : Either String a -> Either String (Maybe a)
maybe (Left err) = Right Nothing
maybe (Right val) = Right (Just val)

export
withDefault : a -> Either String a -> Either String a
withDefault x (Left err) = Right x
withDefault _ els = els

export
string : List String -> Toml -> Either String String
string key toml =
  case get key toml of
    Just (Str x) =>
      Right x

    _ =>
      Left ("Missing or invalid key: " ++ (show key))

export
listStr : List String -> Toml -> Either String (List String)
listStr key toml =
  case get key toml of
    Just (Lst l) =>
      foldl (\acc, el =>
        case (acc, el) of
          (Right l, Str s) =>
            Right (s :: l)
          (Left err, _) =>
            Left err
          _ =>
            Left ("Invalid value type for " ++ (show key))
      ) (Right []) l
    _ =>
      Left ("Missing or invalid key: " ++ (show key))
