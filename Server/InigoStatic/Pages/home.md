
# Inigo Package Manager

[Inigo](https://github.com/hayesgm/inigo) is a package manager for [Idris2](https://www.idris-lang.org/). The goal is to provide a simple package manager to build and share community developed code and projects.

For example, you can use the [Fmt](https://inigo.pm/packages/Base/Fmt) package by including `Base.Fmt=~0.0.1` in your config and running `inigo fetch-deps`. The package and its dependencies can be specified and upgraded.

## Getting Started

Follow the [guide](/guide) to install inigo. Once everything is installed, add `Inigo.toml` to your application, include your dependencies and then pull in packages.
