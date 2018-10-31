module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

-- import Page.NewPage as NewPage

import Browser
import Browser.Events
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Json.Encode
import Page.PageOne as PageOne
import Page.PageWithSubpage as PageWithSubpage
import Page.Top as Top
import Ports
import Route
import Session
import Type.Flags
import Type.LocalStorage
import Url
import Url.Parser as Parser exposing ((</>))
import Viewer



-- TYPES


type Page
    = NotFound Session.Session
    | Top Top.Model
      -- | NewPage NewPage.Model
    | PageOne PageOne.Model
    | PageWithSubpage PageWithSubpage.Model



{-
   ███╗   ███╗ ██████╗ ██████╗ ███████╗██╗
   ████╗ ████║██╔═══██╗██╔══██╗██╔════╝██║
   ██╔████╔██║██║   ██║██║  ██║█████╗  ██║
   ██║╚██╔╝██║██║   ██║██║  ██║██╔══╝  ██║
   ██║ ╚═╝ ██║╚██████╔╝██████╔╝███████╗███████╗
   ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝

-}
-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    }



{-
   ██╗███╗   ██╗██╗████████╗
   ██║████╗  ██║██║╚══██╔══╝
   ██║██╔██╗ ██║██║   ██║
   ██║██║╚██╗██║██║   ██║
   ██║██║ ╚████║██║   ██║
   ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝

-}
-- INIT


init : Type.Flags.Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        localStorage =
            Json.Decode.decodeValue Type.LocalStorage.decode flags.localStorage

        ( model, cmds ) =
            routeUrl url <| Model key (NotFound <| Session.init flags)
    in
    --  On loading the application, we read form local storage. If the object is incorrectly formatted, clear localStorage
    case localStorage of
        Ok success ->
            -- ( model, cmds )
            ( model, Cmd.batch [ cmds, Ports.toLocalStorage { token = "sometoken" } ] )

        Err _ ->
            -- If localstorage decoder failed, clear localstorage
            ( model, Cmd.batch [ cmds, Ports.clearLocalStorage () ] )



{-
   ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
   ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
   ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗
   ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝
   ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
    ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝

-}
-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | OnWindowResize Int Int
    | OnLocalStorageChange Json.Encode.Value
    | TopMsg Top.Msg
      -- | NewPageMsg NewPage.Msg
    | PageOneMsg PageOne.Msg
    | PageWithSubpageMsg PageWithSubpage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            routeUrl url model

        -- Handle a change in localStorage! For example, update the session and send a message to the current page indicating the change
        OnLocalStorageChange msg ->
            let
                localStorage =
                    Debug.log "localstoragechange: " <| Json.Decode.decodeValue Type.LocalStorage.decode msg

                session =
                    extractSession model

                newSession =
                    case localStorage of
                        Ok success ->
                            { session | localStorage = success }

                        Err _ ->
                            { session | localStorage = Nothing }
            in
            updateSession model newSession

        -- Handle this however you'd like for responsive web design! The view in Main.elm and each respective page can change depending on the window size
        OnWindowResize width height ->
            let
                session =
                    extractSession model

                windowSize =
                    { width = width, height = height }
            in
            updateSession model { session | windowSize = windowSize }

        TopMsg msg ->
            case model.page of
                Top m ->
                    mapTopMsg model (Top.update msg m)

                _ ->
                    ( model, Cmd.none )

        PageOneMsg msg ->
            case model.page of
                PageOne m ->
                    mapPageOneMsg model (PageOne.update msg m)

                _ ->
                    ( model, Cmd.none )

        --    NewPage msg ->
        --        case model.page of
        --            NewPage m ->
        --                mapNewPageMsg model (NewPage.update msg m)
        --            _ ->
        --                ( model, Cmd.none )
        PageWithSubpageMsg msg ->
            case model.page of
                PageWithSubpage m ->
                    mapPageWithSubpageMsg model (PageWithSubpage.update msg m)

                _ ->
                    ( model, Cmd.none )



{-
   ██╗   ██╗██╗███████╗██╗    ██╗
   ██║   ██║██║██╔════╝██║    ██║
   ██║   ██║██║█████╗  ██║ █╗ ██║
   ╚██╗ ██╔╝██║██╔══╝  ██║███╗██║
    ╚████╔╝ ██║███████╗╚███╔███╔╝
     ╚═══╝  ╚═╝╚══════╝ ╚══╝╚══╝

-}
-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        session =
            extractSession model
    in
    case model.page of
        NotFound _ ->
            Viewer.view session
                never
                { title = "Page Not Found"
                , body = [ text "Uh oh! Looks like you got lost." ]
                }

        Top m ->
            Viewer.view session TopMsg (Top.view m)

        PageOne m ->
            Viewer.view session PageOneMsg (PageOne.view m)

        -- NewPage _ ->
        -- Viewer.view session             NewPageMsg (NewPage.view m) model.route
        PageWithSubpage m ->
            Viewer.view session PageWithSubpageMsg (PageWithSubpage.view m)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize OnWindowResize
        , Ports.onLocalStorageChange OnLocalStorageChange
        ]



-- MAIN


main : Program Type.Flags.Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



{-
   ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
   ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
   █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
   ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
   ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
   ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

-}
-- Helper functions to send a command from Main to a page


mapTopMsg : Model -> ( Top.Model, Cmd Top.Msg ) -> ( Model, Cmd Msg )
mapTopMsg model ( m, cmds ) =
    ( { model | page = Top m }, Cmd.map TopMsg cmds )


mapPageOneMsg : Model -> ( PageOne.Model, Cmd PageOne.Msg ) -> ( Model, Cmd Msg )
mapPageOneMsg model ( m, cmds ) =
    ( { model | page = PageOne m }, Cmd.map PageOneMsg cmds )



-- mapNewPageMsg : Model -> ( NewPage.Model, Cmd NewPage.Msg ) -> ( Model, Cmd Msg )
-- mapNewPageMsg model ( m, cmds ) =
--     ( { model | page = NewPage m }, Cmd.map NewPageMsg cmds )


mapPageWithSubpageMsg : Model -> ( PageWithSubpage.Model, Cmd PageWithSubpage.Msg ) -> ( Model, Cmd Msg )
mapPageWithSubpageMsg model ( m, cmds ) =
    ( { model | page = PageWithSubpage m }, Cmd.map PageWithSubpageMsg cmds )



-- Extracts the session from the model


extractSession : Model -> Session.Session
extractSession model =
    case model.page of
        NotFound session ->
            session

        Top m ->
            m.session

        PageOne m ->
            m.session

        -- NewPage m ->
        -- m.session
        PageWithSubpage m ->
            m.session



-- Update the session of the active page (This could be changed to send a OnSessionChange Msg rather than using init)
-- However, I think it's better you design your pages such that initializing the page is equivalent to updating the session!


updateSession : Model -> Session.Session -> ( Model, Cmd Msg )
updateSession model session =
    case model.page of
        NotFound _ ->
            ( { model | page = NotFound session }, Cmd.none )

        Top m ->
            mapTopMsg model (Top.init session)

        PageOne m ->
            mapPageOneMsg model (PageOne.init session)

        -- NewPage m ->
        -- mapNewPageMsg model (NewPage.init session)
        PageWithSubpage m ->
            mapPageWithSubpageMsg model (PageWithSubpage.init session m.subpage)



-- ROUTING
{-
   ██████╗  ██████╗ ██╗   ██╗████████╗██╗███╗   ██╗ ██████╗
   ██╔══██╗██╔═══██╗██║   ██║╚══██╔══╝██║████╗  ██║██╔════╝
   ██████╔╝██║   ██║██║   ██║   ██║   ██║██╔██╗ ██║██║  ███╗
   ██╔══██╗██║   ██║██║   ██║   ██║   ██║██║╚██╗██║██║   ██║
   ██║  ██║╚██████╔╝╚██████╔╝   ██║   ██║██║ ╚████║╚██████╔╝
   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝

-}


routeUrl : Url.Url -> Model -> ( Model, Cmd Msg )
routeUrl url model =
    let
        session =
            extractSession model

        route =
            Maybe.withDefault Route.NotFound <| Parser.parse Route.parser url

        newSession =
            { session | route = route }
    in
    case route of
        Route.NotFound ->
            ( { model | page = NotFound newSession }, Cmd.none )

        Route.Top ->
            mapTopMsg model (Top.init newSession)

        -- Route.NewPage ->
        -- mapNewPageMsg newModel (NewPage.init newSession)
        Route.PageOne ->
            mapPageOneMsg model (PageOne.init newSession)

        Route.PageWithSubpage subpage ->
            mapPageWithSubpageMsg model (PageWithSubpage.init newSession subpage)
