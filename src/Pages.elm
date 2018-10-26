module Pages exposing (Page(..))

import Page.DoesNotExist as DoesNotExist
import Page.PageOne as PageOne
import Page.Top as Top
import Session


type Page
    = DoesNotExist Session.Session
    | Top Top.Model
    | PageOne PageOne.Model
