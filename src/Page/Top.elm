module Page.Top exposing (Model, Msg(..), init, update, view)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Session
import Utils exposing (..)
import Viewer



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


view : Model -> Viewer.Details Msg
view model =
    { title = toTitle
    , body =
        [ text "Top"
        , ul [] [ viewLink "/pageone", viewLink "/notexist", viewLink "/pageone/kaldjf", viewLink "/pagewithsubpage/pqwoef", viewLink "/pagewithsubpage/" ]
        ]
    }



-- HELPERS


toTitle =
    "Home"
