
## SemVar

SemVar is a semantic versioning library for Idris2. SemVar allows you to parse, compare and satisfy semantic versions in Idris.

## Getting Started

Simply add `Base.SemVar=^0.0.1` to `Inigo.toml` and run `inigo prod fetch-deps`.

## Parsing Versions

You can parse version strings so long as they comply with the official semantic versioning spec:

```haskell
> parseVersion "4.0.0-alpha1+linux"
MkVersion 4 0 0 (Just "alpha1") (Just "linux")
```

You can also compare versions:

```haskell
> do
	x <- parseVersion "4.0.0"
	y <- parseVersion "4.1.0"
	pure x < y
Just True
```

Also, you can parse SemVar requirements:

```haskell
> map show $ parseRequirement "~1.2.3""
Just ">=1.2.3 <1.3.0"
```

## Satisfaction

You can also use SemVar to attempt to satisfy a set of requirements based on a set of available versions.

```haskell
import SemVar.Sat

-- Note: depB depends on depA >= 1.0.0
versions : List VersionNode
versions =
	[
		(["depA"], (MkVersion 4 0 0 Nothing Nothing), [])
		(["depB"], (MkVersion 1 0 0 Nothing Nothing), [
			[(["depA"], GTE (MkVersion 1 0 0 Nothing Nothing))]
		])
	]

> satisfyAll versions [("depB", GTE (MkVersion 1 0 0 Nothing Nothing)]
Right
	[ (["depB"], MkVersion 1 0 0 Nothing Nothing)
	, (["depA"], MkVersion 4 0 0 Nothing Nothing)
	]
```

This is a simple example, but the solver can try to match a complex tree of requirements.

## Contributing

Feel free to contribute to make the SemVar library better by creating a PR or opening an issue.

## License

This code is licensed under the MIT license. All contributors must release all code under this same license.
