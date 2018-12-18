module View exposing (view)

import Browser
import Helpers.Utils as Utils
import Model exposing (Model)
import Msg exposing (..)
import Pages.PageOne as PageOne
import Pages.PageWithSubpage as PageWithSubpage
import Pages.Top as Top
import Types.Page as Page
import Types.Session as Session
import Viewer



-- Our view function renders the page depending on which page is active.


view : Model -> Browser.Document Msg
view model =
    let
        session =
            Utils.extractSession model
    in
    case model.page of
        Page.NotFound _ ->
            Viewer.view session never Viewer.notFound

        Page.Top m ->
            Viewer.view session TopMsg (Top.view m)

        -- NewPage _ ->
        -- Viewer.view session             NewPageMsg (NewPage.view m) model.route
        Page.PageOne m ->
            Viewer.view session PageOneMsg (PageOne.view m)

        Page.PageWithSubpage m ->
            Viewer.view session PageWithSubpageMsg (PageWithSubpage.view m)
