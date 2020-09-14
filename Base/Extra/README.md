
## Base.Extra

`Base.Extra` is an Idris2 package that adds a variety of nice-to-have functions for core data types from Idris2.

## Installation

Simply add `Base.Extra=^0.0.1` to `Inigo.toml` and run `inigo prod fetch-deps`.

### Buffer

NodeJS bindings for reading from Buffers and converting to and from Base64.

### Debug

Debug functions-- currently just a simple log command which returns its argument after printing it. E.g.

```haskell
myFunc v =
	-- v will be printed whenever this is evaulated
	case Debug.log v:  v of
		...
```

## Contributing

Feel free to make a PR or raise an issue. The goal of this library is to incorporate functions that do not necessarily belong in the prelude, but are likely to be reused through a variety of projects.

## License

This code is licensed under the MIT license. All contributors must release all code under this same license.
