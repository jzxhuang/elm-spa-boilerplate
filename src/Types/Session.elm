module Types.Session exposing (Session, init)

import Json.Decode
import Time
import Types.Flags
import Types.LocalStorage



{-
   The session is used for any data that needs to be shared globally across all pages. All pages have the session in their model.
   You can use this to store info like credentials.
   Currently, I am storing localStorage in session, however it may be better to decode what you need from localStorage and store only that value.
-}


type alias Session =
    { timeAppStarted : Time.Posix
    , windowSize : { width : Int, height : Int }
    , localStorage : Maybe Types.LocalStorage.LocalStorage
    }



-- Initializes a session given some flags


init : Types.Flags.Flags -> Session
init flags =
    let
        localStorage =
            Json.Decode.decodeValue Types.LocalStorage.decode flags.localStorage

        posixTime =
            Time.millisToPosix flags.timeAppStarted
    in
    case localStorage of
        Ok storage ->
            Session posixTime flags.windowSize storage

        Err _ ->
            Session posixTime flags.windowSize Nothing



-- Getters/Setters can go here
