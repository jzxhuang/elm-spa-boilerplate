module Page.PageOne exposing (Model, Msg(..), init, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Session



-- MODEL


type alias Model =
    { session : Session.Session
    }



-- INIT


init : Session.Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Page One"
    , body = [ text "Page One" ]
    }
