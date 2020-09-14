module Client.Action.Login

import Client.Server
import Client.Util
import Data.Buffer
import Extra.Buffer
import Inigo.Async.Base
import Inigo.Async.Fetch
import Inigo.Async.FS
import Inigo.Async.Promise
import Inigo.Util.Url.Url

loginAccountCall : Server -> String -> String -> Promise ()
loginAccountCall server ns passphrase =
  do
    let url = toString (fromHostPath (host server) (accountLoginUrl ns))
    sessionBuf <- assertOk url $ request url "POST" passphrase []
    session <- liftIO $ readAll sessionBuf
    Just sessionFile <- liftIO $ inigoSessionFile
      | Nothing => reject "Login requires $INIGO_SESSION, $INIGO_HOME or $HOME dir"
    fs_writeFile sessionFile session
    log "You are logged into Inigo"
    pure ()

export
loginAccount : Server -> String -> String -> Promise ()
loginAccount =
  loginAccountCall
