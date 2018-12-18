module Update exposing (update)

import Browser
import Browser.Navigation
import Helpers.Utils as Utils
import Json.Decode
import Model exposing (Model)
import Msg exposing (..)
import Pages.PageOne as PageOne
import Pages.PageWithSubpage as PageWithSubpage
import Pages.Top as Top
import Route
import Types.LocalStorage
import Types.Page as Page
import Types.Session as Session
import Url


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        -- When a link is clicked anywhere on our page. There are two types of links, external and internal
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    -- If you'd like to use hash-based routing:
                    -- ( model, Nav.pushUrl model.key (Url.toString (toHashUrl url)) )
                    ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

        -- When the URL changes. This could from something like clicking a link or the browser back/forward buttons
        UrlChanged url ->
            Route.routeUrl url model

        -- Handle this however you'd like for responsive web design! The view in Main.elm and each respective page can change depending on the window size
        OnWindowResize width height ->
            let
                session =
                    Utils.extractSession model

                windowSize =
                    { width = width, height = height }
            in
            Utils.updateSession model { session | windowSize = windowSize }

        -- Handle a change in localStorage. Can be modified to your needs
        -- In the boilerplate, I update the session and send a message to the active page with tne new session
        OnLocalStorageChange msg ->
            let
                localStorage =
                    Json.Decode.decodeValue Types.LocalStorage.decode msg

                session =
                    Utils.extractSession model

                newSession =
                    case localStorage of
                        Ok success ->
                            { session | localStorage = success }

                        Err _ ->
                            { session | localStorage = Nothing }
            in
            Utils.updateSession model newSession

        -- The messages below will send a message received in Main.elm to the respective page.
        TopMsg msg ->
            case model.page of
                Page.Top m ->
                    Utils.mapTopMsg model (Top.update msg m)

                _ ->
                    ( model, Cmd.none )

        --    NewPage msg ->
        --        case model.page of
        --            NewPage m ->
        --                mapNewPageMsg model (NewPage.update msg m)
        --            _ ->
        --                ( model, Cmd.none )
        PageOneMsg msg ->
            case model.page of
                Page.PageOne m ->
                    Utils.mapPageOneMsg model (PageOne.update msg m)

                _ ->
                    ( model, Cmd.none )

        PageWithSubpageMsg msg ->
            case model.page of
                Page.PageWithSubpage m ->
                    Utils.mapPageWithSubpageMsg model (PageWithSubpage.update msg m)

                _ ->
                    ( model, Cmd.none )
