module Main exposing (main)

import Chapters.Testing
import ElmBook exposing (withChapters)
import ElmBook.ElmCSS exposing (Book, book)


main : Book ()
main =
    book "Elm-UI"
        |> withChapters
            [ Chapters.Testing.chapter_
            ]
