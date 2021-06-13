module ElmBook.UI.Docs.Icons exposing (..)

import ElmBook exposing (UIChapter, chapter, renderElements, withElements)
import ElmBook.UI.Icons exposing (..)


docs : UIChapter x
docs =
    let
        color =
            "rgb(0,135,207)"
    in
    chapter "Icons"
        |> withElements
            [ ( "Elm (Color)", iconElmColor 20 )
            , ( "Elm", iconElm { size = 20, color = color } )
            , ( "Github", iconGithub { size = 20, color = color } )
            , ( "Menu", iconMenu { size = 20, color = color } )
            , ( "Close", iconClose { size = 20, color = color } )
            ]
        |> renderElements
