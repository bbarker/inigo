module Inigo.Async.SubtleCrypto.Example

import Inigo.Async.Promise
import Inigo.Async.SubtleCrypto.SubtleCrypto

-- Can be tested in a browser with:
-- idris2 SubtleCrypto/Example.idr --cg node -o testcrypto && cat build/exec/testcrypto | pbcopy

signAndVerify : Promise ()
signAndVerify =
  do
    let keyAlgo = (KeyECDSA P256)
    let algo = (ECDSA Sha256)
    (pub, priv) <- generateKey keyAlgo (Sign <&> Verify)
    privEnc <- exportKey priv
    privImp <- importKey keyAlgo Sign privEnc
    signature <- sign algo privImp "hello world"
    pubEnc <- exportKey pub
    pubImp <- importKey keyAlgo Verify pubEnc
    success <- verify algo pubImp signature "hello world"
    log ("Success: " ++ show success)

hashPassword : Promise ()
hashPassword =
  do
    salt <- getRand 8
    let algo = (PBKDF2 Sha256 salt 10000)
    hashed <- hash algo "my password"
    log ("Hashed: " ++ hashed)

main : IO ()
main =
  resolve hashPassword (\_ => pure ()) (\_ => pure ())
