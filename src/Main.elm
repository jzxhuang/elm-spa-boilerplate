module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Events
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.DoesNotExist as DoesNotExist
import Page.PageOne as PageOne
import Page.Top as Top
import Pages
import Session
import Url
import Url.Parser as Parser



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



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Pages.Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        _ =
            Debug.log "url" url
    in
    stepUrl url { key = key, page = Pages.DoesNotExist Session.empty }



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | OnWindowResize Int Int
    | TopMsg Top.Msg
    | PageOneMsg PageOne.Msg


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
            stepUrl url model

        OnWindowResize width height ->
            ( model, Cmd.none )

        TopMsg msg ->
            case Debug.log "top" model.page of
                Pages.Top topModel ->
                    stepTop model (Top.update msg topModel)

                _ ->
                    ( model, Cmd.none )

        PageOneMsg msg ->
            case Debug.log "p1" model.page of
                Pages.PageOne m ->
                    let
                        ( modelPageOne, cmdPageOne ) =
                            PageOne.update msg m
                    in
                    ( { model | page = Pages.PageOne modelPageOne }, Cmd.map PageOneMsg cmdPageOne )

                -- stepPageOne model (PageOne.update msg pageOneModel)
                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Browser.Events.onResize OnWindowResize ]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        Pages.DoesNotExist _ ->
            { title = "Page Not Found"
            , body = [ text "Does not exist" ]
            }

        Pages.PageOne _ ->
            { title = "Page One Found"
            , body = [ text "Page One" ]
            }

        _ ->
            { title = "top"
            , body = [ text "top", ul [] [ viewLink "/pageone", viewLink "/notexist", viewLink "/pageone/kaldjf" ] ]
            }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]



-- ROUTING FROM PACKAGE.ELM-LANG.ORG
-- These functions send a command to a page


stepPageOne : Model -> ( PageOne.Model, Cmd PageOne.Msg ) -> ( Model, Cmd Msg )
stepPageOne model ( pageOne, cmds ) =
    ( { model | page = Pages.PageOne pageOne }
    , Cmd.map PageOneMsg cmds
    )


stepTop : Model -> ( Top.Model, Cmd Top.Msg ) -> ( Model, Cmd Msg )
stepTop model ( top, cmds ) =
    ( { model | page = Pages.Top top }
    , Cmd.map TopMsg cmds
    )


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        session =
            extractSession model

        parser =
            Parser.oneOf
                [ Parser.map (stepTop model (Top.init session)) Parser.top
                , Parser.map (stepPageOne model (PageOne.init session)) (Parser.s "pageone")
                ]
    in
    case Debug.log "msg" <| Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = Pages.DoesNotExist session }
            , Cmd.none
            )



-- Parses url and navigates to the correct page by updating the Model and sending the appropriate command


coolparser : Model -> Session.Session -> Parser.Parser (( Model, Cmd Msg ) -> a) a
coolparser model session =
    Parser.oneOf
        [ Parser.map (stepTop model (Top.init session)) Parser.top
        , Parser.map (stepPageOne model (PageOne.init session)) (Parser.s "pageone")
        ]


extractSession : Model -> Session.Session
extractSession model =
    case model.page of
        Pages.DoesNotExist session ->
            session

        Pages.Top m ->
            m.session

        Pages.PageOne m ->
            m.session
