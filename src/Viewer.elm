module Viewer exposing (Details, view, viewFooter, viewHeader)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Session
import Url.Builder
import Utils



{-
   This module builds the view. Every individual page's view function returns a Viewer.Details,
   which is used to generate a Browser.Document msg in this module
-}


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

        -- , Utils.logo 256
        , Html.map msg <| div [ class "container", class "main", style "height" (String.fromInt (session.windowSize.height - headerHeight - footerHeight) ++ "px") ] details.body
        , viewFooter
        ]
    }



-- HEADER
-- This header is statically generated. You'd likely want this to be dynamic in some way based on the active page & session
-- You could create an addtional field in Viewer.Details for a header, and create this header in Main.elm or in each individual page's view


viewHeader : Html msg
viewHeader =
    div [ class "header", class "container" ]
        [ div [ class "logo" ] [ viewLogo ]
        , div [ class "nav-links" ]
            [ a [ href "/" ] [ text "Home" ]
            , a [ href "/pageone" ] [ text "Page One" ]
            , a [ href "/pagewithsubpage/hello" ] [ text "Page With Subpage" ]

            --    , a [ href "newpage" ] [ text "New Page" ]
            ]
        ]



-- FOOTER


viewFooter : Html msg
viewFooter =
    div [ class "footer", class "container" ]
        [ text "A simple, no-frills boilerplate for creating robust Single Page Applications (SPAs) in Elm."
        , a [ href "https://github.com/jzxhuang/elm-spa-boilerplate" ] [ text "Check it out on Github!" ]
        , text "© 2018 - present Jeffrey Huang."
        ]



-- LOGO


viewLogo : Html msg
viewLogo =
    a [ href "/", style "text-decoration" "none" ] [ Utils.logo 32 ]



-- STYLING HELPERS (lazy, hard-coded styling)


headerHeight =
    60


footerHeight =
    60
