module Session exposing (Session, init)

import Json.Decode
import Route
import Time
import Type.Flags
import Type.LocalStorage


type alias Session =
    { timeAppStarted : Time.Posix
    , windowSize : { width : Int, height : Int }
    , route : Route.Route
    , localStorage : Maybe Type.LocalStorage.LocalStorage
    }



-- Initializes a session given some flags


init : Type.Flags.Flags -> Session
init flags =
    let
        localStorage =
            Debug.log "decoded" <| Json.Decode.decodeValue Type.LocalStorage.decode flags.localStorage

        posixTime =
            Time.millisToPosix flags.timeAppStarted
    in
    case localStorage of
        Ok storage ->
            Session posixTime flags.windowSize Route.NotFound storage

        Err _ ->
            Session posixTime flags.windowSize Route.NotFound Nothing



-- Getters/Setters can go here
