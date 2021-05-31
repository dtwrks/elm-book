module UIBook.UI.Docs.Footer exposing (..)

import ElmBook exposing (chapter, themeBackground, withBackgroundColor, withSection)
import UIBook.ElmCSS exposing (UIChapter)
import UIBook.UI.Footer exposing (view)


docs : UIChapter x
docs =
    chapter "Footer"
        |> withBackgroundColor themeBackground
        |> withSection view
