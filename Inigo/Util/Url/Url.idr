module Inigo.Util.Url.Url

-- TODO: Improve here
public export
record Url where
  constructor MkUrl
  host : String
  path : String

export
fromHostPath : String -> String -> Url
fromHostPath host path =
  MkUrl host path

export
toString : Url -> String
toString url =
  host url ++ path url
