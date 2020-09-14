
## Toml

A [Toml](https://toml.io/en/) parser for Idris2.

## Getting Started

Simply add `Base.Toml=^0.0.1` to `Inigo.toml` and run `inigo prod fetch-deps`.

## Parsing

To parse Toml, simply call `parseToml`, e.g.:

```haskell
> parseToml "[myKey]\n myVal=1 \n other=\"hello\""
Just
	[ (["myKey", "myVal"], Num 1)
	, (["myKey", "other"], Str "hello")
	]
```

You can also encode a Toml document:

```haskell
> let toml =
	Just
	[ (["myKey", "myVal"], Num 1)
	, (["myKey", "other"], Str "hello")
	]
  in Toml.encode toml
"
myKey.myVal=1\n
myKey.other=\"hello\"
"
```

Finally, you can pull keys out of Toml:

```haskell
> let toml =
	Just
	[ (["myKey", "myVal"], Num 1)
	, (["myKey", "other"], Str "hello")
	]
  in Toml.get ["myKey", "myVal"]
Just (Num 1)
```

or sub-keys of a Toml document:

```haskell 
> let toml =
	Just
	[ (["myKey", "myVal"], Num 1)
	, (["myKey", "other"], Str "hello")
	]
  in Toml.getToml ["myKey"]
[ (["myVal", Num 1])
, (["other", Str "hello"])
]
```

## Support

We currently do not support RFC-3339 dates, floating point numbers or inline tables.

## Contributing

Feel free to contribute and improve the library and support more features of Toml. You can create a pull request or raise an issue.

## License

This code is licensed under the MIT license. All contributors must release all code under this same license.
