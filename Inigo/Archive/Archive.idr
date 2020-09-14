module Inigo.Archive.Archive

import Toml
import Data.List

export
encode : List (List String, String) -> String
encode =
	Toml.encode . map (\(k, v) => (k, Str v))

export
decode : String -> Maybe (List (List String, String))
decode toml =
	do
		doc <- parseToml toml
		res <- foldl accumulate (Just []) doc
		pure (reverse res)
	where
		accumulate : Maybe (List (List String, String)) -> (List String, Value) -> Maybe (List (List String, String))
		accumulate Nothing _ = Nothing
		accumulate (Just acc) (key, Str str) = Just ((key, str) :: acc)
		accumulate _ _ = Nothing
