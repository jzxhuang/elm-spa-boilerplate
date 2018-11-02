module Page.Top exposing (Model, Msg(..), init, update, view)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Session
import Utils exposing (..)
import Viewer



{-
   This is the top page - the page that is displayed when the url path is "/"
-}
-- MODEL


type alias Model =
    { session : Session.Session
    }



-- INIT


init : Session.Session -> ( Model, Cmd Msg )
init session =
    ( Model session, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Viewer.Details msg
view model =
    { title = toTitle
    , body =
        [ h1 [] [ text "Boilerplate for Single Page Applications (SPAs) in Elm" ]
        , div [] [ text "This is a boilerplate for writing Single Page Applications in Elm. It is written in Elm with no JavaScript aside from usage of localStorage." ]
        , div [] [ text "Some highlights of this boilerplate:" ]
        , highlights
        , div [] [ text "Here's some links to try out the client-side routing:" ]
        , ul [] [ viewLink "/pageone", viewLink "/pagewithsubpage/subpage-name", viewLink "/pagewithsubpage/adpoifjawef" ]
        , div [] [ text "You can handle 404 errors however you'd like - for exampple, rendering a static page, or redirecting to the home page. Here's a bunch of links that route to the 404 page:" ]
        , ul [] [ viewLink "/notexist", viewLink "/invalidpage", viewLink "/pageone/kaldjf", viewLink "/pagewithsubpage/" ]
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
