module UIBook.UI.Docs.Search exposing (..)

import ElmBook exposing (chapter, logAction, logActionWithString, themeBackground, withBackgroundColor, withDescription, withSection, withTwoColumns)
import UIBook.ElmCSS exposing (UIChapter)
import UIBook.UI.Search exposing (view)


docs : UIChapter x
docs =
    chapter "Search"
        |> withBackgroundColor themeBackground
        |> withSection
            (view
                { value = ""
                , onInput = logActionWithString "onInput"
                , onFocus = logAction "onFocus"
                , onBlur = logAction "onBlur"
                }
            )
