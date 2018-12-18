module Types.Flags exposing (Flags)

import Json.Encode
import Types.LocalStorage



-- The expected flags on initialization, sent from JavaScript (static/index.js)


type alias Flags =
    { timeAppStarted : Int
    , windowSize : { width : Int, height : Int }
    , localStorage : Json.Encode.Value
    }
