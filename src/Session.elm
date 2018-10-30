module Session exposing (Session, WindowSize, init)

import Types


type alias Session =
    { timeAppStarted : Int
    , windowSize : Types.WindowSize
    }


init : Types.Flags -> Session
init flags =
    Session flags.timeAppStarted flags.windowSize



-- Getters/Setters can go here


type alias WindowSize =
    { width : Int, height : Int }
