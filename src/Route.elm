module Route exposing (Route(..), defaultRoute, fromUrlToRoute, parser, routeToString)

import Pages
import Url
import Url.Parser as Parser exposing ((</>))



-- The list of Routes (pages)


type Route
    = Top
    | Page1
    | PageWithSubpages String



-- The default Route


defaultRoute =
    Top



-- From a url (passed from js?) to a Route. Defaults to Top


fromUrlToRoute : Url.Url -> Route
fromUrlToRoute url =
    Maybe.withDefault defaultRoute (Parser.parse parser url)



-- Parser


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Top Parser.top
        , Parser.map Page1 (Parser.s "page1")
        , Parser.map PageWithSubpages (Parser.s "pagewithsubpages" </> Parser.string)
        ]



-- Converts a Route to string. This can then be pushed to the browser history to navigate within the application
-- For example: Ports.pushHistoryState <| Route.routeToString Route.Page1


routeToString : Route -> String
routeToString route =
    let
        pieces =
            case route of
                Top ->
                    []

                Page1 ->
                    [ "page1" ]

                PageWithSubpages subpage ->
                    [ "pagewithsubpages", subpage ]
    in
    "/" ++ String.join "/" pieces
