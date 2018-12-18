module Msg exposing (Msg(..))

import Browser
import Json.Encode
import Pages.PageOne as PageOne
import Pages.PageWithSubpage as PageWithSubpage
import Pages.Top as Top
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | OnWindowResize Int Int
    | OnLocalStorageChange Json.Encode.Value
    | TopMsg Top.Msg
      -- | NewPageMsg NewPage.Msg
    | PageOneMsg PageOne.Msg
    | PageWithSubpageMsg PageWithSubpage.Msg
