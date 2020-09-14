module Markdown.Format.Text

import Extra.String
import Markdown.Data

-- toTextEl : MarkdownEl -> String
-- toTextEl (Header level text) = "#" ++ text -- TODO: Level
-- toTextEl (Paragraph text) = text

-- ||| Convert a Markdown value into its string representation.
-- public export
-- toText : Markdown -> String
-- toText (Doc els) =
--   join "\n" (map toTextEl els)

public export
toText : Markdown -> String
toText x = "TODO"
