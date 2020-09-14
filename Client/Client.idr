module Client.Client

import Client.Action.Archive
import Client.Action.Build
import Client.Action.BuildDeps
import Client.Action.Exec
import Client.Action.FetchDeps
import Client.Action.Login
import Client.Action.Pull
import Client.Action.Push
import Client.Action.Register
import Client.Action.Test
import Client.Server
import Client.Util
import Data.List
import Data.Maybe
import Data.Strings
import Extra.Either
import Extra.String
import Fmt
import Inigo.Account.Account
import Inigo.Async.Promise
import Inigo.Package.CodeGen
import SemVar
import System

||| TODO: Overall, this should be converted to a
|||       better dependently-typed CLI system
fail : String -> IO ()
fail str =
  do
    putStrLn str
    exitFailure

-- Note: not total
requirePrompt : String -> (String -> List String) -> IO String
requirePrompt prompt validator =
  do
    putStr prompt
    x <- map trim $ getLine
    case validator x of
      [] =>
        pure x
      errs =>
        do
          putStrLn (fmt "Invalid: %s\n" (join ", " errs))
          requirePrompt prompt validator

data Action : Type where
  Archive : String -> String -> Action
  Build : CodeGen -> Action
  BuildDeps : Action
  Exec : CodeGen -> List String -> Action
  Extract : String -> String -> Action
  FetchDeps : Server -> Bool -> Bool -> Action
  Login : Server -> Action
  Pull : Server -> String -> String -> (Maybe Version) -> Action
  Push : Server -> String -> Action
  Register : Server -> Action
  Test : CodeGen -> Action

fetchDepsAction : String -> Bool -> Bool -> Maybe Action
fetchDepsAction serverName includeDevDeps build =
  do
    server <- getServer serverName
    pure $ FetchDeps server includeDevDeps build

getAction : List String -> Maybe Action
getAction [_, "archive", packageFile, outFile] =
  Just (Archive packageFile outFile)

getAction [_, "extract", archiveFile, outPath] =
  Just (Extract archiveFile outPath)

getAction [_, "build-deps"] =
  Just BuildDeps

getAction [_, "build", codeGen] =
  do
    codeGen <- getCodeGen codeGen
    pure $ Build codeGen

getAction [_, "build"] =
  Just (Build Node)

getAction (_ :: "exec" :: userArgs) =
  Just (Exec Node userArgs)

getAction (_ :: "fetch-deps" :: serverName :: extraArgs) =
  let
    build = not $ isJust $ find (== "--no-build") extraArgs
    includeDevDeps = isJust $ find (== "--dev") extraArgs
  in
    fetchDepsAction serverName includeDevDeps build

getAction [_, "push", serverName, archive] =
  do
    server <- getServer serverName
    pure $ Push server archive

getAction [_, "pull", serverName, packageNS, packageName] =
  do
    server <- getServer serverName
    pure $ Pull server packageNS packageName Nothing

getAction [_, "pull", serverName, packageNS, packageName, versionStr] =
  do
    server <- getServer serverName
    version <- parseVersion versionStr
    pure $ Pull server packageNS packageName (Just version)

getAction [_, "test", codeGen] =
  do
    codeGen <- getCodeGen codeGen
    pure $ Test codeGen

getAction [_, "test"] =
  Just (Test Node)

getAction [_, "register", serverName] =
  do
    server <- getServer serverName
    pure $ Register server

getAction [_, "login", serverName] =
  do
    server <- getServer serverName
    pure $ Login server

getAction _ = Nothing

getActionIO : IO (Maybe Action)
getActionIO =
  map getAction getArgs

runAction : Action -> IO ()
runAction (Archive packageFile outFile) =
  do
    putStrLn ("Archiving " ++ packageFile ++ " to " ++ outFile)
    run (buildArchive packageFile outFile)

runAction (Extract archiveFile outPath) =
  do
    putStrLn ("Extracting " ++ archiveFile ++ " from " ++ outPath)
    run (extractArchive archiveFile outPath)

runAction BuildDeps =
  do
    putStrLn "Building deps..."
    run buildDeps

runAction (Build codeGen) =
  run (build codeGen)

runAction (Exec codeGen userArgs) =
  run (exec codeGen True userArgs) -- TODO: Make build a flag

runAction (FetchDeps server includeDevDeps build) =
  do
    putStrLn ("Feching deps from " ++ toString server ++ (if includeDevDeps then " including dev deps" else ""))
    run (fetchDeps server includeDevDeps build)

runAction (Push server archive) =
  do
    Just session <- readSessionFile
      | Nothing => fail "Must be logged in to push package."
    putStrLn ("Pushing " ++ archive ++ " to " ++ toString server)
    run (push server session archive)

runAction (Pull server packageNS packageName mVersion) =
  do
    putStrLn (fmt "Pulling %s.%s [%s] from %s" packageNS packageName (show mVersion) (toString server))
    run (pull server packageNS packageName mVersion)

runAction (Register server) =
  do
    putStrLn "Welcome to Inigo. Let's create an account."
    ns <- requirePrompt "Namespace [your username]: " nsValid
    email <- requirePrompt "Email: " emailValid
    passphrase <- requirePrompt "Passphrase: " passphraseValid
    putStrLn (fmt "Creating account %s..." ns)
    run (registerAccount server ns email passphrase)

runAction (Login server) =
  do
    putStrLn "Welcome back to Inigo."
    ns <- requirePrompt "Namespace [your username]: " nsValid
    passphrase <- requirePrompt "Passphrase: " (const [])
    putStrLn "Logging in..."
    run (loginAccount server ns passphrase)

runAction (Test codeGen) =
  run (test codeGen)

short : String -> Maybe String
short "archive" = Just "archive <pkg_file> <out_file>: Archive a given package"
short "extract" = Just "extract <archive_file> <out_path>: Extract a given archive to directory"
short "build-deps" = Just "build-deps: Build all deps"
short "fetch-deps" = Just "fetch-deps <server>: Fetch and build all deps (opts: --no-build, --dev)"
short "build" = Just "build <code-gen=node>: Build program under given code gen"
short "exec" = Just "exec ...args: Execute program with given args [WIP codegen]"
short "test" = Just "test: Run tests via IdrTest"
short "push" = Just "push <server> <pkg_file>: Push a package to remote"
short "pull" = Just "pull <server> <package_ns> <package_name> <version?>: Pull a package from remote"
short "register" = Just "register <server>: Register an account namespace"
short "login" = Just "login <server>: Login to an account"
short _ = Nothing

usage : IO ()
usage =
  let
    descs = join "\n\t" $ mapMaybe id $
      map short ["push", "pull", "archive", "extract", "build-deps", "fetch-deps", "exec", "build", "test", "register", "login"]
  in
    fail ("usage: Inigo <command> <...args>\n\n\t" ++ descs)

main : IO ()
main =
  do
    Just action <- getActionIO
      | Nothing => usage
    runAction action
