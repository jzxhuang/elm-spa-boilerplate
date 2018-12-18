module Main exposing (init, main, subscriptions, update, view)

-- import Pages.NewPage as NewPage

import Browser
import Helpers.Utils as Utils
import Init
import Model exposing (Model)
import Msg exposing (..)
import Subscriptions
import Types.Flags as Flags
import Update
import View


init =
    Init.init


subscriptions =
    Subscriptions.subscriptions


update =
    Update.update


view =
    View.view



-- VIEW
-- SUBSCRIPTIONS
-- MAIN


main : Program Flags.Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- FUNCTIONS
