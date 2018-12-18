module Helpers.Utils exposing (extractSession, mapPageOneMsg, mapPageWithSubpageMsg, mapTopMsg, updateSession)

import Model exposing (Model)
import Msg exposing (..)
import Pages.PageOne as PageOne
import Pages.PageWithSubpage as PageWithSubpage
import Pages.Top as Top
import Types.Page as Page
import Types.Session as Session



-- Extracts the session from the model


extractSession : Model -> Session.Session
extractSession model =
    case model.page of
        Page.NotFound session ->
            session

        Page.Top m ->
            m.session

        Page.PageOne m ->
            m.session

        -- NewPage m ->
        -- m.session
        Page.PageWithSubpage m ->
            m.session



-- Helper functions to send a command from Main to a page


mapTopMsg : Model -> ( Top.Model, Cmd Top.Msg ) -> ( Model, Cmd Msg )
mapTopMsg model ( m, cmds ) =
    ( { model | page = Page.Top m }, Cmd.map TopMsg cmds )


mapPageOneMsg : Model -> ( PageOne.Model, Cmd PageOne.Msg ) -> ( Model, Cmd Msg )
mapPageOneMsg model ( m, cmds ) =
    ( { model | page = Page.PageOne m }, Cmd.map PageOneMsg cmds )



-- mapNewPageMsg : Model -> ( NewPage.Model, Cmd NewPage.Msg ) -> ( Model, Cmd Msg )
-- mapNewPageMsg model ( m, cmds ) =
--     ( { model | page = NewPage m }, Cmd.map NewPageMsg cmds )


mapPageWithSubpageMsg : Model -> ( PageWithSubpage.Model, Cmd PageWithSubpage.Msg ) -> ( Model, Cmd Msg )
mapPageWithSubpageMsg model ( m, cmds ) =
    ( { model | page = Page.PageWithSubpage m }, Cmd.map PageWithSubpageMsg cmds )



-- Update the session of the active page (This could be changed to send a OnSessionChange Msg rather than using init)
-- However, I think it's better you design your pages such that initializing the page is equivalent to updating the session!


updateSession : Model -> Session.Session -> ( Model, Cmd Msg )
updateSession model session =
    case model.page of
        Page.NotFound _ ->
            ( { model | page = Page.NotFound session }, Cmd.none )

        Page.Top m ->
            mapTopMsg model (Top.init session)

        Page.PageOne m ->
            mapPageOneMsg model (PageOne.init session)

        -- NewPage m ->
        -- mapNewPageMsg model (NewPage.init session)
        Page.PageWithSubpage m ->
            mapPageWithSubpageMsg model (PageWithSubpage.init session m.subpage)
