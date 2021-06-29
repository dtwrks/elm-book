module ElmBook.UI.Docs.Footer exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, renderComponent, renderComponentList, withComponent, withComponentOptions)
import ElmBook.Component
import ElmBook.UI.Footer exposing (view)
import ElmBook.UI.Helpers exposing (themeBackground)


docs : Chapter x
docs =
    chapter "Footer"
        |> withComponentOptions
            [ ElmBook.Component.background themeBackground
            ]
        |> renderComponent view
