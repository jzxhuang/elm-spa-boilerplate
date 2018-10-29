module Page.PageWithSubpage exposing (Model, Msg(..), init, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Session



-- MODEL


type alias Model =
    { session : Session.Session
    , subpage : String
    }



-- INIT


init : Session.Session -> String -> ( Model, Cmd Msg )
init session subpage =
    ( Model session subpage, Cmd.none )



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
    , body = [ text "Page One", text <| "subpage: " ++ model.subpage ]
    }
