module Inigo.Package.CodeGen

public export
data CodeGen : Type where
  Node : CodeGen

export
cmdArgs : CodeGen -> String -> (String, List String)
cmdArgs Node target = ("node", [target])

export
toString : CodeGen -> String
toString Node = "node"

-- TODO: Invert map?
export
getCodeGen : String -> Maybe CodeGen
getCodeGen "node" = Just Node
getCodeGen _ = Nothing
