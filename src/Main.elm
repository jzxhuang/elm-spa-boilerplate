module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

-- import Page.NewPage as NewPage

import Browser
import Browser.Events
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.PageOne as PageOne
import Page.PageWithSubpage as PageWithSubpage
import Page.Top as Top
import Session
import Url
import Url.Parser as Parser exposing ((</>))



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



-- TYPES


type Page
    = NotFound Session.Session
    | Top Top.Model
      -- | NewPage NewPage.Model
    | PageOne PageOne.Model
    | PageWithSubpage PageWithSubpage.Model



-- FUNCTIONS
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



-- ROUTING


routeUrl : Url.Url -> Model -> ( Model, Cmd Msg )
routeUrl url model =
    let
        session =
            extractSession model

        pageNotFound =
            ( { model | page = NotFound session }, Cmd.none )
    in
    Maybe.withDefault pageNotFound <| Parser.parse (parser model session) url


parser : Model -> Session.Session -> Parser.Parser (( Model, Cmd Msg ) -> a) a
parser model session =
    Parser.oneOf
        [ route Parser.top (mapTopMsg model (Top.init session))
        , route (Parser.s "pageone") (mapPageOneMsg model (PageOne.init session))
        , route (Parser.s "pagewithsubpage" </> Parser.string)
            (\subpage -> mapPageWithSubpageMsg model (PageWithSubpage.init session subpage))

        --, route (Parser.s "newpage") (mapNewPageMsg model (NewPage.init session))
        ]


route : Parser.Parser a b -> a -> Parser.Parser (b -> c) c
route parser_ handler =
    Parser.map handler parser_



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        _ =
            Debug.log "url" url
    in
    routeUrl url <| Model key (NotFound Session.empty)



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
    | TopMsg Top.Msg
      -- | NewPageMsg NewPage.Msg
    | PageOneMsg PageOne.Msg
    | PageWithSubpageMsg PageWithSubpage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case Debug.log "xxx" message of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            routeUrl url model

        OnWindowResize width height ->
            -- Handle this however you'd like for responsive web design!
            -- ie, Send a message to the active page indicating the new window size
            ( model, Cmd.none )

        TopMsg msg ->
            case Debug.log "top" model.page of
                Top m ->
                    mapTopMsg model (Top.update msg m)

                _ ->
                    ( model, Cmd.none )

        PageOneMsg msg ->
            case Debug.log "p1" model.page of
                PageOne m ->
                    mapPageOneMsg model (PageOne.update msg m)

                _ ->
                    ( model, Cmd.none )

        PageWithSubpageMsg msg ->
            case model.page of
                PageWithSubpage m ->
                    mapPageWithSubpageMsg model (PageWithSubpage.update msg m)

                _ ->
                    ( model, Cmd.none )



--    NewPage msg ->
--        case model.page of
--            NewPage m ->
--                mapNewPageMsg model (NewPage.update msg m)
--            _ ->
--                ( model, Cmd.none )
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Browser.Events.onResize OnWindowResize ]



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
    case model.page of
        NotFound _ ->
            { title = "Page Not Found"
            , body = [ text "Does not exist" ]
            }

        PageOne _ ->
            { title = "Page One Found"
            , body = [ text "Page One" ]
            }

        PageWithSubpage _ ->
            { title = "New Page"
            , body = [ text "New Page" ]
            }

        -- NewPage _ ->
        --     { title = "New Page"
        --     , body = [ text "New Page" ]
        --     }
        _ ->
            { title = "top"
            , body = [ text "top", ul [] [ viewLink "/pageone", viewLink "/notexist", viewLink "/pageone/kaldjf", viewLink "pagewithsubpage/pqwoef" ] ]
            }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


extractSession : Model -> Session.Session
extractSession model =
    case model.page of
        NotFound session ->
            session

        Top m ->
            m.session

        -- NewPage m ->
        -- m.session
        PageOne m ->
            m.session

        PageWithSubpage m ->
            m.session



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }