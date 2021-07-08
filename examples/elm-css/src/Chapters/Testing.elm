module Chapters.Testing exposing (chapter_)

import ElmBook.Chapter exposing (chapter, renderComponent)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (div, p, text)


chapter_ : Chapter x
chapter_ =
    chapter "Testing…"
        |> renderComponent
            (div []
                [ p [] [ text "Cooper" ]
                , p [] [ text "- Every day, once a day, give yourself a present." ]
                ]
            )
