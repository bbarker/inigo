module Markdown.Format.Html

import Extra.String
import Markdown.Data

-- TODO: This probably isn't total
-- TODO: Make this safe
htmlElementProps : String -> List (String, String) -> String -> String
htmlElementProps el props contents =
  "<" ++ el ++ (showProps props) ++ ">" ++ contents ++ "</" ++ el ++ ">"
    where
      showProps : List (String, String) -> String
      showProps ps = -- Dunno why this wouldn't type check when I split function defs
        case ps of
          [] => ""
          p :: ps =>
            let (k, v) = p
            in " " ++ k ++ "=\"" ++ v ++ "\"" ++ (showProps ps)

htmlElement : String -> String -> String
htmlElement el contents =
  htmlElementProps el [] contents

||| TODO: Escape HTML-type elements
escapeText : String -> String
escapeText =
  (replace "<" "&lt;")
  . (replace ">" "&gt;")

mutual
  inlineToHtml : Inline -> String
  inlineToHtml (Text text) = text
  inlineToHtml (Pre text) = htmlElement "tt" (escapeText text)
  inlineToHtml (CodeBlock text _) = htmlElement "pre" (escapeText text)
  inlineToHtml (Italics inlines) = htmlElement "em" (inlinesToHtml inlines)
  inlineToHtml (Bold inlines) = htmlElement "strong" (inlinesToHtml inlines)
  inlineToHtml (Image alt src) = htmlElementProps "img" [("src", src), ("alt", alt)] ""
  inlineToHtml (Link desc href) = htmlElementProps "a" [("href", href)] desc
  inlineToHtml (Html tag inlines) = htmlElement tag (inlinesToHtml inlines)

  inlinesToHtml : List Inline -> String
  inlinesToHtml inlines =
    join "" (map inlineToHtml inlines)

blockToHtml : Block -> String
blockToHtml (Header level inlines) = htmlElement ("h" ++ (show level)) (inlinesToHtml inlines)
blockToHtml (Paragraph inlines) = htmlElement "p" (inlinesToHtml inlines)

||| Convert a Markdown value into Html
public export
toHtml : Markdown -> String
toHtml (Doc els) =
  join "\n" (map blockToHtml els)
