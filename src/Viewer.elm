module Viewer exposing (Details, view, viewFooter, viewHeader)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Session
import Url.Builder
import Utils


type alias Details msg =
    { title : String
    , body : List (Html msg)
    }



-- VIEW


view : Session.Session -> (a -> msg) -> Details a -> Browser.Document msg
view session msg details =
    { title = details.title ++ Utils.genericTitle
    , body =
        [ viewHeader
        , Utils.logo 256
        , Html.map msg <| div [] details.body
        , viewFooter
        ]
    }



-- HEADER
-- This header is statically generated.
-- You'd likely want this to be dynamic in some way based on active page & session
-- So, generate a header in each page's view, or in the view of Main.elm, or with another helper module


viewHeader : Html msg
viewHeader =
    div [ style "background-color" "#eeeeee", class "header" ]
        (viewLogo
            :: [ a [ href "/" ] [ text "Home" ]
               , a [ href "pageone" ] [ text "Page One" ]
               , a [ href "pagewithsubpage/hello" ] [ text "Page With Subpage" ]

               --    , a [ href "newpage" ] [ text "New Page" ]
               ]
        )



-- FOOTER


viewFooter : Html msg
viewFooter =
    div [ class "footer" ]
        [ text "A simple boilerplate for Single Page Applications in Elm. "
        , a [ href "https://github.com/jzxhuang/elm-spa-boilerplate" ] [ text "Check it out on Github!" ]
        , text "Licenced under the MIT licence. © 2018 - present Jeffrey Huang."
        ]



-- LOGO


viewLogo : Html msg
viewLogo =
    a [ href "/", style "text-decoration" "none" ] [ Utils.logo 32 ]
