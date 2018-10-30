module Types exposing (Flags, WindowSize)


type alias WindowSize =
    { width : Int, height : Int }


type alias Flags =
    { timeAppStarted : Int
    , windowSize : WindowSize
    }
