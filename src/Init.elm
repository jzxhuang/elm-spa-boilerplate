module Init exposing (init)

import Browser.Navigation
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg)
import Ports
import Route
import Types.Flags as Flags
import Types.LocalStorage
import Types.Page as Page
import Types.Session as Session
import Url



-- To initialize the app, we route the URL to determine what page should be rendered.
-- We also get some information from the flags that will be stored in the Session


init : Flags.Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        localStorage =
            Json.Decode.decodeValue Types.LocalStorage.decode flags.localStorage

        ( model, cmds ) =
            Route.routeUrl url <| Model key (Page.NotFound <| Session.init flags)
    in
    --  On loading the application, we read form local storage. If the object is incorrectly formatted, clear localStorage
    case localStorage of
        Ok success ->
            ( model, cmds )

        Err _ ->
            -- If localstorage decoder failed, clear localstorage
            ( model, Cmd.batch [ cmds, Ports.clearLocalStorage () ] )
