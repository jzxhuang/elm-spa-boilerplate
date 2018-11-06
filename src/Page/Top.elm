module Page.Top exposing (Model, Msg(..), init, update, view)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import Json.Decode
import Ports
import Session
import Utils exposing (..)
import Viewer



{-
   This is the top page - the page that is displayed when the url path is "/"
-}
-- MODEL


type alias Model =
    { session : Session.Session
    , localStorageInputField : String
    }



-- INIT


init : Session.Session -> ( Model, Cmd Msg )
init session =
    ( Model session "", Cmd.none )



-- UPDATE


type Msg
    = NoOp
    | LocalStorageInputFieldChange String
    | SetLocalStorage
    | ClearLocalStorage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        -- Updates the value of the localStorage input field in the model
        LocalStorageInputFieldChange input ->
            ( { model | localStorageInputField = input }, Cmd.none )

        -- Sets the value in local storage (from Set localStorage button, onEnter listener of the localStorage input field)
        SetLocalStorage ->
            let
                localStorage =
                    { token = model.localStorageInputField }

                session =
                    model.session

                newSession =
                    { session | localStorage = Just localStorage }
            in
            ( { model | localStorageInputField = "", session = newSession }, Ports.toLocalStorage localStorage )

        -- Clears localStorage (from Clear localStorage button)
        ClearLocalStorage ->
            let
                session =
                    model.session

                newSession =
                    { session | localStorage = Nothing }
            in
            ( { model | session = newSession }, Ports.clearLocalStorage () )



-- VIEW


view : Model -> Viewer.Details Msg
view model =
    { title = toTitle
    , body =
        [ h1 [] [ text "elm-spa-boilerplate" ]
        , div [ class "content" ]
            [ -- Intro and features
              div [] [ text "A simple, no-frills boilerplate for creating delightful Single Page Applications (SPAs) in Elm. Everything you need to get started with no extra clutter. Just clone, compile, and get right to coding!" ]
            , div [] [ text "Some highlights of this boilerplate:" ]
            , highlights

            -- Valid links
            , div [] [ text "Here's some links to try out the client-side routing. Be sure to try using your browser's Back and Forward buttons, and refresh the page anytime!" ]
            , ul [] [ viewLink "/pageone", viewLink "/pagewithsubpage/subpage-name", viewLink "/pagewithsubpage/adpoifjawef" ]

            -- Invalid links demonstrating 404 redirecting (assuming the server is set up to redirect 404 to index.html)
            , div [] [ text "You can handle 404 errors however you'd like - for example, rendering a static page, or routing to the home page. I chose to show a static 404 page - Here's a bunch of links that route there:" ]
            , ul [] [ viewLink "/doesnotexist", viewLink "/invalidpage", viewLink "/pageone/kaldjf", viewLink "/pagewithsubpage/" ]

            -- Demo of localStorage (set, clear, current value)
            , div [] [ text "The required ports, decoder and JS handlers for using localStorage is initalized for you. Check it out:" ]
            , div []
                [ input [ class "input", style "width" "250px", placeholder "Set the value in localStorage...", Html.Events.onInput LocalStorageInputFieldChange, onEnter SetLocalStorage, value model.localStorageInputField ] [] ]
            , div []
                [ button [ Html.Events.onClick SetLocalStorage ] [ text "Set localStorage" ]
                , button [ Html.Events.onClick ClearLocalStorage ] [ text "Clear localStorage" ]
                ]
            , div []
                [ text <|
                    "Current value in localStorage is: "
                        ++ (case model.session.localStorage of
                                Just item ->
                                    "{\"token\": " ++ item.token ++ "}"

                                Nothing ->
                                    "Nothing"
                           )
                ]
            ]
        ]
    }



-- HELPERS


toTitle =
    "Home"


highlights =
    ul []
        [ li [] [ text "Client-side routing that uses pushState navigation and the forward slash `/` as the path separator." ]
        , li [] [ text "Search Engine Optimization (SEO) friendly - unique Title for each page." ]
        , li [] [ text "Support for localStorage, with the necessary ports and JS handlers already initalized." ]
        , li [] [ text "Support for responsive site design by listening for window size changes and always storing window size in the model." ]
        , li [] [ text "Built with webpack." ]
        , li [] [ text "Well-commented code!" ]
        ]



-- Custom event listener for the 'Enter' key being pressed


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.Decode.succeed msg

            else
                Json.Decode.fail "not ENTER"
    in
    Html.Events.on "keydown" (Json.Decode.andThen isEnter Html.Events.keyCode)
