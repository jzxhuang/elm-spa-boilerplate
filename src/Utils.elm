module Utils exposing (genericTitle, viewLink)

import Html exposing (..)
import Html.Attributes exposing (..)


genericTitle =
    " - Elm SPA Boilerplate"


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
