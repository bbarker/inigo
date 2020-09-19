module Client.Action.Init

import Client.Skeleton.Skeleton
import Data.List
import Fmt
import Inigo.Async.Base
import Inigo.Async.FS
import Inigo.Async.Promise
import Inigo.Util.Path.Path

export
init : Skeleton -> String -> String -> Promise ()
init skeleton packageNS packageName =
  do
    all $ map writeTmplFile (getFiles skeleton (packageNS, packageName))
    log (fmt "Successfully built %s" (toString skeleton))
  where
    -- TODO: We probably can make this faster with less reversing
    dropRight : Nat -> List a -> List a
    dropRight n l =
      reverse $ drop n $ reverse l

    ensureParent : List String -> Promise ()
    ensureParent [] = pure ()
    ensureParent (x :: []) = pure ()
    ensureParent l =
      fs_mkdir True (pathUnsplit (dropRight 1 l))

    writeTmplFile : (List String, String) -> Promise ()
    writeTmplFile (path, contents) =
      do
        ensureParent path
        fs_writeFile (pathUnsplit path) contents
