module ElmBook.UI.Docs.Search exposing (..)

import ElmBook.Actions exposing (logAction, logActionWithString)
import ElmBook.Chapter exposing (Chapter, chapter, renderComponent, withComponentOptions)
import ElmBook.Component
import ElmBook.UI.Helpers exposing (themeBackground)
import ElmBook.UI.Search exposing (view)


docs : Chapter x
docs =
    chapter "Search"
        |> withComponentOptions
            [ ElmBook.Component.background themeBackground
            ]
        |> renderComponent
            (view
                { value = ""
                , onInput = logActionWithString "onInput"
                , onFocus = logAction "onFocus"
                , onBlur = logAction "onBlur"
                }
            )
