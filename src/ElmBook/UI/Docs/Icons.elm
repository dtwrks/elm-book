module ElmBook.UI.Docs.Icons exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, renderWithComponentList, withComponentList)
import ElmBook.UI.Icons exposing (..)


docs : Chapter x
docs =
    let
        color =
            "rgb(0,135,207)"
    in
    chapter "Icons"
        |> withComponentList
            [ ( "Elm (Color)", iconElmColor 20 )
            , ( "Elm", iconElm { size = 20, color = color } )
            , ( "Github", iconGithub { size = 20, color = color } )
            , ( "Menu", iconMenu { size = 20, color = color } )
            , ( "Close", iconClose { size = 20, color = color } )
            ]
        |> renderWithComponentList """
Simple inline icons built with `elm/svg` – not that exciting but it works. 🤷
"""
