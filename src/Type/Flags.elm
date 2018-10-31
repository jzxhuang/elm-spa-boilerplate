module Type.Flags exposing (Flags)

import Json.Encode
import Type.LocalStorage


type alias Flags =
    { timeAppStarted : Int
    , windowSize : { width : Int, height : Int }
    , localStorage : Json.Encode.Value
    }
