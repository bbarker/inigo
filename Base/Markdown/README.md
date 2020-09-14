
## Markdown

Markdown is a markdown parser and renderer for Idris2.

## Getting Started

Simply add `Base.Markdown=^0.0.1` to `Inigo.toml` and run `inigo prod fetch-deps`.

## Parsing and Rendering

You can simply run `Markdown.parse` to parse Markdown text:

```haskell
import Markdown

> Markdown.parse "# Hello world\n\nHow are _you_?"
Just Doc
	[ Header 1 [ Text "Hello world" ]
	, Paragraph [ Text "How are ", Italics "you", Text "?" ]
	]
```

Then you can render that doc to Html or Text.

```haskell
map MarkdownFormat.Html.toHtml $ Markdown.parse "# Hello world\n\nHow are _you_?"
<h1>Hello world</h1>
<p>How are <em>you</em>!</p>
```

## Supported Features

* Headers `#`
* Paragraphs
* Text
* Italics `_`
* Bold `**`
* Links `[]()`
* Images `![]()`
* Html `<>` (Basic Support)
* Preformatted Text
* Code Fences

## Contributing

There are a lot of features to add and support, so feel free to contribute and improve this library. Please make an issue for any bugs.

## Changelog

* `0.0.4` - Fix issues regarding whitespace
* `0.0.3` - Add support for `pre` and code blocks
* `0.0.2` - Fix non-HTML brackets
* `0.0.1` - Initial commit

## License

This code is licensed under the MIT license. All contributors must release all code under this same license.
