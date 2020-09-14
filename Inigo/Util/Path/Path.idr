module Inigo.Util.Path.Path

import Data.List
import Extra.String

-- TODO: Make these smarter
export
joinPath : String -> String -> String
joinPath x y =
  x ++ "/" ++ y

export
(</>) : String -> String -> String
(</>) = joinPath
infixr 5 </>

export
pathSplit : String -> List String
pathSplit =
  split '/'

export
pathUnsplit : List String -> String
pathUnsplit =
  join "/"

export
parent : String -> String
parent =
  pathUnsplit . reverse . drop 1 . reverse . pathSplit

||| TODO: Spec out this behavior better
export
relativeTo : String -> String -> String
relativeTo root path =
	let
		rootParts = pathSplit root
		pathParts = pathSplit path
		intersection = intersect rootParts pathParts
	in
		pathUnsplit $ drop (length intersection) pathParts
