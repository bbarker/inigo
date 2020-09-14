
## Fmt

`Fmt` is an Idris2 package for compile-time string formatting. Think of it like `printf` but with type-checking.

## Examples

```haskell
let x = "world" in
fmt "Hello %s." x
```

```haskell
let name = "Tim", age=30 in
fmt "Name: %s, Age: %d" name age
```

## Credit

This package repurposes the code from `chrisdone` in this gist: https://gist.github.com/chrisdone/672efcd784528b7d0b7e17ad9c115292

## Contributing

We'd like to expand this project to include more interesting types. Feel free to expand on the current parser.
