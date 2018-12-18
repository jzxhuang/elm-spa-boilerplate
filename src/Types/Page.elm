module Types.Page exposing (Page(..))

import Pages.PageOne as PageOne
import Pages.PageWithSubpage as PageWithSubpage
import Pages.Top as Top
import Types.Session as Session



-- Page: each time you need to add/remove a page, this needs to be updated appropriately
-- Each page holds the respective pages model, with the exception of the 404 NotFound page type


type Page
    = NotFound Session.Session
    | Top Top.Model
      -- | NewPage NewPage.Model
    | PageOne PageOne.Model
    | PageWithSubpage PageWithSubpage.Model
