## Color

Idris package to add **color** to your app!

## Getting Started

Add `Base.Color=^0.0.1` to `Inigo.toml` and run `inigo prod fetch-deps`.

## Decorate

You can decorate with colors, background colors, etc. For example:

```haskell
decorate (Text Red) "Hello"
```

or to add multiple styles:

```haskell
decorate (Text Red & BG Blue & Bold) "Hello"
```

## Supported

Currently supported colors are:

```
Black : Color
Red : Color
Green : Color
Yellow : Color
Blue : Color
Magenta : Color
Cyan : Color
White : Color
```

Supported decorators are:

```haskell
Text : Color -> Decorator
BG : Color -> Decorator
Bold : Decorator
Underline : Decorator
Reversed : Decorator
```

## Contributing

Feel free to open up PRs to add support for more features.

## License

This code is licensed under the MIT license. All contributors must release all code under this same license.
