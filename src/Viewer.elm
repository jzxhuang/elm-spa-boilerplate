module Viewer exposing (Details, notFound, view)

import Browser
import Helpers.Misc as Misc
import Html exposing (..)
import Html.Attributes exposing (..)
import Types.Session as Session
import Url.Builder



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
    { title = details.title ++ Misc.genericTitle
    , body =
        [ viewHeader

        -- , Misc.logo 256
        , Html.map msg <| div [ class "container", class "main", style "height" (String.fromInt (session.windowSize.height - headerHeight - footerHeight) ++ "px") ] details.body
        , viewFooter
        ]
    }



-- HEADER
-- This header is statically generated. You'd likely want this to be dynamic in some way based on the active page & session
-- You could create an additional field in Viewer.Details for a header, and create this header in Main.elm or in each individual page's view


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
        [ text "A simple, no-frills boilerplate for creating delightful Single Page Applications (SPAs) in Elm."
        , a [ href "https://github.com/jzxhuang/elm-spa-boilerplate" ] [ text "Check it out on Github!" ]
        , text "© 2018 - present Jeffrey Huang."
        ]



-- 404 PAGE (NotFound)


notFound : Details msg
notFound =
    { title = "Page Not Found"
    , body =
        [ div [ class "not-found" ]
            [ div [ style "font-size" "12em" ] [ text "404" ]
            , h1 [ style "font-size" "3.5em" ] [ text "Page Not Found" ]
            , h3 [ style "font-size" "1.5em" ]
                [ text "Oops - Looks like you got lost or clicked a bad link! "
                , a [ href "/" ] [ text "Click here " ]
                , text "to go back to the home page."
                ]
            ]
        ]
    }



-- LOGO


viewLogo : Html msg
viewLogo =
    a [ href "/", style "text-decoration" "none" ] [ Misc.logo 32 ]



-- STYLING HELPERS (lazy, hard-coded styling)


headerHeight =
    60


footerHeight =
    60
