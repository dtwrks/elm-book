module ElmBook.UI.Docs.Footer exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, renderComponent, withComponentOptions)
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
