module Chapters.Testing exposing (chapter_)

import Element exposing (..)
import ElmBook.Chapter exposing (chapter, renderComponent)
import ElmBook.ElmUI exposing (Chapter)


chapter_ : Chapter x
chapter_ =
    chapter "Testing…"
        |> renderComponent
            (column [ padding 20, spacing 20 ]
                [ text "HAL"
                , text "- My F.P.C. shows an impending failure of the antenna orientation unit."
                ]
            )
