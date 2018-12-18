module Subscriptions exposing (subscriptions)

import Browser.Events
import Model exposing (Model)
import Msg exposing (..)
import Ports


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize OnWindowResize
        , Ports.onLocalStorageChange OnLocalStorageChange
        ]
