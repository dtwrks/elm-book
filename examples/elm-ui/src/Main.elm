module Main exposing (main)

import Chapters.Testing
import ElmBook exposing (withChapters)
import ElmBook.ElmUI exposing (Book, book)


main : Book ()
main =
    book "Elm-UI"
        |> withChapters
            [ Chapters.Testing.chapter_
            ]
