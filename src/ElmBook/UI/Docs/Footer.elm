module ElmBook.UI.Docs.Footer exposing (..)

import ElmBook exposing (UIChapter, chapter, renderElementsWithBackground, themeBackground, withBackgroundColor, withElement)
import ElmBook.UI.Footer exposing (view)


docs : UIChapter x
docs =
    chapter "Footer"
        |> withBackgroundColor themeBackground
        |> withElement view
        |> renderElementsWithBackground themeBackground
