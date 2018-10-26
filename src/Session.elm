module Session exposing (Session, WindowSize, empty)


type alias Session =
    { someData : Maybe String

    -- windowsize
    -- time started
    }


empty : Session
empty =
    Session Nothing



-- Getters/Setters can go here


type alias WindowSize =
    { width : Int, height : Int }
