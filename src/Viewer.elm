module Viewer exposing (Details, view, viewFooter, viewHeader)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Route
import Session
import Url.Builder
import Utils


type alias Details msg =
    { title : String
    , body : List (Html msg)
    }



-- VIEW


view : (a -> msg) -> Details a -> Route.Route -> Browser.Document msg
view msg details route =
    { title = details.title ++ Utils.genericTitle
    , body =
        [ viewHeader route
        , Html.map msg <| div [] details.body
        , viewFooter
        ]
    }



-- HEADER


viewHeader : Route.Route -> Html msg
viewHeader route =
    div [ style "background-color" "#eeeeee" ]
        ([ text "Logo" ]
            ++ List.map (toHeaderLink route) headerLinks
        )



-- FOOTER


viewFooter : Html msg
viewFooter =
    div [ class "footer" ]
        [ text "A simple boilerplate for Single Page Applications in Elm. "
        , a [ href "https://github.com/jzxhuang/elm-spa-boilerplate" ] [ text "Check it out on Github!" ]
        , text "Licenced under the MIT licence. © 2018 - present Jeffrey Huang."
        ]



-- HELPERS


headerLinks =
    [ Route.Top
    , Route.PageOne
    , Route.PageWithSubpage ""

    -- , "Route.NewPage"
    ]


toHeaderLink : Route.Route -> Route.Route -> Html msg
toHeaderLink match route =
    if Route.toHeaderString route == Route.toHeaderString match then
        a [ href <| Route.routeHref route, class "active" ] [ text <| Route.toHeaderString route ]

    else
        a [ href <| Route.routeHref route ] [ text <| Route.toHeaderString route ]
