module Server.Template.Template

import Extra.String

-- Simple template library, can be vastly improved

ident : String -> String
ident k =
  "<%% " ++ k ++ " %%>"

export
template : String -> List (String, String) -> String
template tmpl =
  foldl (\acc, (k, v) => replace (ident k) v acc) tmpl
