module ElmBook.UI.Docs.Search exposing (..)

import ElmBook exposing (UIChapter, chapter, logAction, logActionWithString, renderElementsWithBackground, themeBackground, withBackgroundColor, withElement)
import ElmBook.UI.Search exposing (view)


docs : UIChapter x
docs =
    chapter "Search"
        |> withBackgroundColor themeBackground
        |> withElement
            (view
                { value = ""
                , onInput = logActionWithString "onInput"
                , onFocus = logAction "onFocus"
                , onBlur = logAction "onBlur"
                }
            )
        |> renderElementsWithBackground themeBackground
