module Inigo.Account.Account

import Data.List
import Data.Maybe
import Extra.String
import Fmt
import Toml
import Inigo.Async.SubtleCrypto.SubtleCrypto -- TODO: We don't use Async, maybe split package?

||| An account registered with an Inigo server
public export
record Account where
  constructor MkAccount
  ns : String
  email : String
  kdf : Algorithm
  hash : String

public export
Show Account where
  show (MkAccount ns email _ _) = fmt "MkAccount{ns=%s, email=%s, kdf=***, hash=***}" ns email

public export
Eq Account where
  (MkAccount ns0 email0 kdf0 hash0) == (MkAccount ns1 email1 kdf1 hash1) =
    ns0 == ns1 && email0 == email1 && kdf0 == kdf1 && hash0 == hash1

||| Encodes an account into a Toml data type
toToml : Account -> Toml
toToml (MkAccount ns email kdf hash) =
  [ (["ns"], Str ns)
  , (["email"], Str email)
  ] ++ toTomlKdf kdf ++
  [ (["hash"], Str hash)
  ]
  where
    toTomlKdf : Algorithm -> Toml
    toTomlKdf (PBKDF2 sha salt iterations) =
      [ (["kdf", "type"], Str "PBKDF2")
      , (["kdf", "sha"], Str (encodeSha sha))
      , (["kdf", "salt"], Str salt)
      , (["kdf", "iterations"], Num iterations)
      ]

    toTomlKdf (ECDSA sha) =
      [ (["kdf", "type"], Str "ECDSA")
      , (["kdf", "sha"], Str (encodeSha sha))
      ]

||| Decodes a Toml data value into an account object
export
fromToml : Toml -> Maybe Account
fromToml toml =
  do
    ns <- str ["ns"] toml
    email <- str ["email"] toml
    kdf <- fromTomlKdf (getToml ["kdf"] toml)
    hash <- str ["hash"] toml
    pure $ (MkAccount ns email kdf hash)
  where
    str : List String -> Toml -> Maybe String
    str key toml =
      case get key toml of
        Just (Str v) =>
          Just v

        _ =>
          Nothing

    int : List String -> Toml -> Maybe Int
    int key toml =
      case get key toml of
        Just (Num v) =>
          Just v

        _ =>
          Nothing

    fromTomlKdfType : String -> Toml -> Maybe Algorithm
    fromTomlKdfType "PBKDF2" toml =
      do
        sha <- (str ["sha"] toml) >>= decodeSha
        salt <- str ["salt"] toml
        iterations <- int ["iterations"] toml
        pure (PBKDF2 sha salt iterations)
    fromTomlKdfType "ECDSA" toml =
      do
        sha <- (str ["sha"] toml) >>= decodeSha
        pure (ECDSA sha)
    fromTomlKdfType _ _ = Nothing

    fromTomlKdf : Toml -> Maybe Algorithm
    fromTomlKdf toml =
      do
        type <- str ["type"] toml
        fromTomlKdfType type toml

||| Encodes an account into a Toml doc
export
encode : Account -> String
encode =
  encode . toToml

||| Decodes an account from a Toml doc
export
decode : String -> Maybe Account
decode str =
  parseToml str >>= fromToml

-- TODO: Improve quality of Validity parsing, e.g. by passing back a hidden type
export
require : List (Bool, String) -> List String
require conds =
  foldl accumulateErr [] conds
  where
    accumulateErr : List String -> (Bool, String) -> List String
    accumulateErr acc (cond, err) =
      if cond then
        acc
      else
        (err :: acc)

export
nsValid : String -> List String
nsValid str =
  let
    unpacked = unpack str
  in
    require
      [ (length str >= 4, "Namespace must be at least 4 chars")
      , ( (foldl (\acc, el => acc && (isAlphaNum el)) True unpacked) , "Namespace must be alpha-numeric")
      , (fromMaybe False $ map isUpper $ head' unpacked, "Must start with an uppercase letter") --'
      ]

export
emailValid : String -> List String
emailValid email =
  require $ case split '@' email of
    (first :: last :: []) =>
      do
      [ ( length first > 0, "Invalid email username" )
      , ( length last > 0, "Invalid email domain" )
      ]
    _ =>
      [ ( False, "Email must contain a single @ sign" ) ]

export
passphraseValid : String -> List String
passphraseValid passphrase =
  require
    [ ( length passphrase > 10, "Please use a strong passphrase" ) ]

export
mkAccount : String -> String -> Algorithm -> String -> String -> Either String Account
mkAccount ns email kdf passphrase hash =
  do
    validate (nsValid ns)
    validate (emailValid email)
    validate (passphraseValid passphrase)
    pure $ MkAccount ns email kdf hash
  where
    validate : List String -> Either String ()
    validate [] = Right ()
    validate errs = Left (join ", " errs)
