
# Guide

Inigo is a package manager for Idris2 to help use and share Idris code.

## Installation

First, you'll need to install `inigo`. Note: we currently only support JavaScript code-gen on the client, but we plan to add support to Chez and other code-gens soon.

You can either download a release from [releases](https://github.com/hayesgm/inigo/releases) or bootstrap your own.

### Downloading a Release

Once you've downloaded a release, you'll need to make it available in your path.

### Bootstrapping

You can run the bootstrap Makefile command on Linux-type environments to bootstrap Inigo. Since Inigo depends on packages in Inigo, you'll need to bootstrap to get the components you need.

```bash
git clone https://github.com/hayesgm/inigo
cd inigo && make bootstrap
```

If all goes well, you'll want to make inigo available in your path, e.g. via:

```bash
cp build/exec/inigo /usr/local/bin
chmod +x /usr/local/bin/inigo
-- TODO: Handle env program
```

## Create an app

Let's create a new app and use Inigo to manage our packages:

``` bash
inigo new MyApp
```

This will create a skeleton app with an `Inigo.toml`. This configuration file will allow you to specify dependencies and automatically generates your Idris `ipkg` file for you.

For example, we can add to our dependencies:

**Inigo.toml**

```toml
...
[deps]
Base.Color="~0.0.1"
Base.Fmt="~0.0.1"
```

This allows us to use the [Color](https://inigo.pm/packages/Color) and [Fmt](https://inigo.pm/packages/Fmt) libraries. Then install the libaries and build the dependencies with:

```bash
inigo fetch-deps prod --build
```

Finally, you can use this in your app:

**MyApp.idr**

```idris
module MyApp

import Color
import Fmt

main = IO ()
main =
	do
		name <- getLine
		putStrLn (fmt "Hello %s" (decorate (Color Blue) name))
```

## Publishing a Package

To publish a package, you'll need to first register an account with Inigo to claim a namespace.

```
inigo register
```

Then, you should login to your namespace:

```
inigo login
```

Finally, you can push your new app:

```
inigo push ./Inigo.toml
```

## Questions

Feel free to ask questions on [GitHub issues](https://github.com/hayesgm/inigo/issues).

## Contributing

Please feel free to open issues on GitHub or create pull requests. A key focus of this project will be to expand support for ChezScheme and other code-gens, as well as better support for Windows and other operating systems. Additionally, we would like to refactor much of the code to make better use of dependent types.
