module Route exposing (parser, paths, route, routeUrl)

import Helpers.Utils as Utils
import Model exposing (Model)
import Msg exposing (..)
import Pages.PageOne as PageOne
import Pages.PageWithSubpage as PageWithSubpage
import Pages.Top as Top
import Types.Page as Page
import Types.Session as Session
import Url
import Url.Parser as Parser exposing ((</>))



-- The following functions create the client-side router. Update "parser" and "paths" for each page you add/remove


routeUrl : Url.Url -> Model -> ( Model, Cmd Msg )
routeUrl url model =
    let
        session =
            Utils.extractSession model

        -- If you'd like to use hash-based routing:
        -- hashUrl =
        --     { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    in
    -- If you'd like to use hash-based routing:
    -- case Parser.parse (parser model session) hashUrl of
    case Parser.parse (parser model session) url of
        Just success ->
            success

        Nothing ->
            ( { model | page = Page.NotFound session }, Cmd.none )


route : Parser.Parser a b -> a -> Parser.Parser (b -> c) c
route parser_ handler =
    Parser.map handler parser_



-- URL Parser tha maps a URL to a Page, and initializes that page.


parser : Model -> Session.Session -> Parser.Parser (( Model, Cmd Msg ) -> a) a
parser model session =
    Parser.oneOf
        [ route Parser.top (Utils.mapTopMsg model (Top.init session))
        , route (Parser.s paths.pageOne)
            (Utils.mapPageOneMsg model (PageOne.init session))

        -- , route (Parser.s paths.newPage)
        --     (mapNewPageMsg model (NewPage.init session))
        , route (Parser.s paths.pageWithSubpage </> Parser.string)
            (\subpage -> Utils.mapPageWithSubpageMsg model (PageWithSubpage.init session subpage))
        ]



--  This holds the paths for each page. Update as needed for each page you add/remove


paths =
    { top = ""
    , pageOne = "pageone"
    , pageWithSubpage = "pagewithsubpage"

    --, newPage = "newpage"
    }



-- Uncomment  this helper function if you need to use hash-based routing.
-- toHashUrl : Url.Url -> Url.Url
-- toHashUrl url =
--     { url | fragment = Just url.path, path = "" }
