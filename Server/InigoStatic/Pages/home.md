
# Inigo Package Manager

[Inigo](https://github.com/hayesgm/inigo) is a package manager for [Idris2](https://www.idris-lang.org/). The goal is to provide a simple package manager to build and share community developed code and projects.

For example, you can use the [Fmt](https://inigo.pm/packages/Base/Fmt) package by including `Base.Fmt=~0.0.1` in your config and running `inigo fetch-deps`. The package and its dependencies can be specified and upgraded.

## Getting Started

Follow the [Guide](/guide) to install and get started with Inigo. Once everything is installed, you can add `Inigo.toml` to your application, include your dependencies and then pull in packages.

## Features

 * Packager manager featuring semantic versioning of packages
 * Dependency resolution system with support for dev dependencies
 * Native Toml configuration files that compile to `ipkg`s
 * Light wrapper around native Idris2 commands (e.g. `idris2 --build`, etc)
 * Built-in (optional) unit test framework: [IdrTest](https://inigo.pm/packages/Base/IdrTest)
 * Support for registering accounts and pushing your own community packages

## Vision

The goal of Inigo is to be a simple package manager and light wrapper around Idris2. Inigo is fully built in Idris2 and can bootstrap itself. Builds and core commands call out to the `idris2` command. Packages are hosted on CloudFlare using Workers running an Idris2 program (via the JavaScript codegen). The client is also native Idris2 and should soon support being compiled to JavaScript, Chez or other code generators.

## Contributing

Please feel free to discuss on [GitHub Issues](https://github.com/hayesgm/inigo/issues) or in [#fp Slack](https://functionalprogramming.slack.com/).
