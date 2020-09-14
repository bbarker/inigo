module Server.InigoServer.Server

import Inigo.Async.Base
import Inigo.Async.CloudFlare.Worker as Worker
import Inigo.Async.Promise
import Server.InigoServer.Handler

server : Promise ()
server =
  do
    Worker.serve handler
    never -- wait forever

export
main : IO ()
main =
  run server
