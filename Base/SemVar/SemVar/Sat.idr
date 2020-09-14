module SemVar.Sat

import Extra.Debug as Debug
import Data.List
import Data.Maybe
import Extra.Op
import Fmt
import SemVar.Data

public export
VersionNode : Type
VersionNode = (List String, Version, List (List String, Requirement))

compareBy : Ord b => (a -> b) -> (a -> a -> Ordering)
compareBy f =
  (\x, y => compare (f x) (f y))

versOf : VersionNode -> Version
versOf (_, v, _) = v

pkgVersOf : VersionNode -> (List String, Version)
pkgVersOf (p, v, _) = (p, v)

matchPkgVers : VersionNode -> VersionNode -> Bool
matchPkgVers x y =
  pkgVersOf x == pkgVersOf y

||| I think the idea is that we'll walk the list of requirements and
||| narrow down from the list of choices until either we've satisfied
||| all requirements or we've found one we can't solve.
||| Two caveats:
|||  a. We'll need to pick up new reqs as we go (for sub deps)
|||    i. Note: we can't let ourselves get into an infinite loop here and may have to track "completed"
|||  b. If we end up with multiple acceptable packages, we'll just choose the latest of all available options
satisfyAll_ : List VersionNode -> List (List String, Version) -> List (List String, Requirement) -> Either String (List (List String, Version))
satisfyAll_ versions pinned [] = Right pinned
satisfyAll_ versions pinned ((pkg, req) :: reqs) =
  -- let _ = Debug.log "Resolving req" (pkg, req, pinned) in
  case step pinned versions (pkg, req) of
    Left Nothing =>
      -- This current req is incompatible with current reqs
      Left (fmt "Package %s req %s is incompatible" (show pkg) (show req))
    Left (Just _) =>
      -- This current req is already satisfied
      -- let _ = Debug.log "Using existing package for" pkg in
      satisfyAll_ versions pinned reqs
    Right matches =>
      -- Let's see if any of these matches work
      let
        -- Try the highest versions first
        sorted = sortBy (compareBy versOf) matches
        -- This new req can't be satisfied, quit
        -- TODO: Show possible versions?
        baseErr = fmt "Cannot match %s req %s" (show pkg) (show req)
      in
        foldl tryVersion (Left baseErr) sorted
  where
    tryVersion : Either String (List (List String, Version)) -> VersionNode -> Either String (List (List String, Version))
    tryVersion (Right r) _ = Right r
    tryVersion (Left _) hd =
      case find (matchPkgVers hd) versions of
        Nothing =>
          -- TODO: Should we collect errors
          Left (fmt "Cannot find deps for %s" (show hd))

        Just (_, _, depReqs) =>
          -- Good, we found at least one potential match, let's start by just recursing on head
          -- TODO: We need to accumulate here, maybe?
          -- let _ = Debug.log " " hd in
          -- Non-TCO and non-total
          satisfyAll_ versions ((pkgVersOf hd) :: pinned) (reqs ++ depReqs)

    matchReq : List VersionNode -> (List String, Requirement) -> List VersionNode
    matchReq versions (pkg, req) =
      filter (\(name, version, _) => name == pkg && satisfy req version) versions

    step : List (List String, Version) -> List VersionNode -> (List String, Requirement) -> Either (Maybe Version) (List VersionNode)
    step pinned versions (pkg, req) =
      case find ((== pkg) . fst) pinned of
        Just (_, pin) =>
          if satisfy req pin then
            Left (Just pin)
          else
            Left Nothing
        Nothing =>
          Right $ matchReq versions (pkg, req)

export
satisfyAll : List VersionNode -> List (List String, Requirement) -> Either String (List (List String, Version))
satisfyAll versions reqs =
  satisfyAll_ versions [] reqs
