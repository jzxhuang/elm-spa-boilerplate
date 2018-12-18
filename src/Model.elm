module Model exposing (Model)

import Browser.Navigation
import Types.Page as Page


type alias Model =
    { key : Browser.Navigation.Key -- Required in a Browser.application
    , page : Page.Page
    }
