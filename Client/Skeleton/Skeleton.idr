module Client.Skeleton.Skeleton

import Client.Skeleton.BaseWithTest.InigoTOML
import Client.Skeleton.BaseWithTest.Package
import Client.Skeleton.BaseWithTest.Test.Suite
import Client.Skeleton.BaseWithTest.Test.Test

public export
data Skeleton : Type where
  BaseWithTest : Skeleton

export
toString : Skeleton -> String
toString BaseWithTest = "BaseWithTest"

export
describe : Skeleton -> String
describe BaseWithTest = "base skeleton with tests"

export
fromString : String -> Maybe Skeleton
fromString "BaseWithTest" = Just BaseWithTest
fromString _ = Nothing

export
getFiles : Skeleton -> (String, String) -> List (List String, String)
getFiles BaseWithTest vars =
  [ ( Client.Skeleton.BaseWithTest.InigoTOML.name vars
    , Client.Skeleton.BaseWithTest.InigoTOML.build vars
    )
  , ( Client.Skeleton.BaseWithTest.Package.name vars
    , Client.Skeleton.BaseWithTest.Package.build vars
    )
  , ( Client.Skeleton.BaseWithTest.Test.Suite.name vars
    , Client.Skeleton.BaseWithTest.Test.Suite.build vars
    )
  , ( Client.Skeleton.BaseWithTest.Test.Test.name vars
    , Client.Skeleton.BaseWithTest.Test.Test.build vars
    )
  ]
