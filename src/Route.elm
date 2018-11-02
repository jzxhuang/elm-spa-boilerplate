module Route exposing (Route(..), defaultRoute, parser, paths, routeHref, toHeaderString)

import Url.Builder as Builder
import Url.Parser as Parser exposing ((</>), map, oneOf, top)


type Route
    = NotFound
    | Top
      --| NewPage
    | PageOne
    | PageWithSubpage String


defaultRoute =
    NotFound


parser : Parser.Parser (Route -> a) a
parser =
    oneOf
        [ map Top top
        , map PageOne (Parser.s paths.pageOne)
        , map PageWithSubpage (Parser.s paths.pageWithSubpage </> Parser.string)

        --, map NewPage (Parser.s "newpage")
        ]


paths =
    { top = ""
    , pageOne = "pageone"
    , pageWithSubpage = "pagewithsubpage"

    --, newPage = "newpage"
    }


routeHref : Route -> String
routeHref route =
    case route of
        Top ->
            Builder.absolute [ paths.top ] []

        PageOne ->
            Builder.absolute [ paths.pageOne ] []

        PageWithSubpage _ ->
            Builder.absolute [ paths.pageWithSubpage, "default" ] []

        --NewPage ->
        -- (Builder.absolute [paths.newPage])
        _ ->
            ""



-- FOR HEADER


toHeaderString : Route -> String
toHeaderString route =
    case route of
        Top ->
            "Home"

        PageOne ->
            "Page One"

        PageWithSubpage _ ->
            "Page With Subpage"

        -- NewPage ->
        -- "New Page"
        _ ->
            ""
