
# About Inigo

Inigo is an Idris2 package manager written in Idris2. Packages are hosted directly on CloudFlare's CDN. This site itself and the manager are hosted on the same edge nodes and is run on the server as an Idris2 program compiled to JavaScript.

Specifically, Inigo is split into two parts: the client and the server. The server is an Idris2 program compiled to JavaScript and deployed as a CloudFlare worker. Packages are archived (currently using a compressed TOML-based storage system) and stored in CloudFlare's KV store. This website, itself, is served by the server.

The Inigo client also part of the Idris2 program. While the server will most likely stay in JavaScript (or in the future, possibly WASM), the client should support an array of languages. Currently, we use JavaScript since there's not a unified strategy for concurrency or HTTP clients. Once this is supported in the Idris2 core, we will make sure that the Inigo client compiles to all core codegens (e.g. JavaScript, Chez, WASM, OCaml, etc).

The code for this site, the manager and the client are hosted on [GitHub](https://github.com/hayesgm/inigo). To upgrade this site or the app, open a pull request or [raise an issue](https://github.com/hayesgm/inigo/issues).

Inigo is a community-supported project and is released under the MIT license.
