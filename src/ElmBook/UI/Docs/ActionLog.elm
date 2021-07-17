module ElmBook.UI.Docs.ActionLog exposing (..)

import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (Chapter, chapter, renderWithComponentList, withComponentList)
import ElmBook.UI.ActionLog exposing (list, preview, previewEmpty)


docs : Chapter x
docs =
    chapter "ActionLog"
        |> withComponentList
            [ ( "Empty", previewEmpty )
            , ( "Preview"
              , preview
                    { lastActionIndex = 0
                    , lastAction = ( "Context", "Action" )
                    , onClick = logAction "onClick"
                    }
              )
            , ( "List"
              , list
                    (List.range 1 10
                        |> List.map (\index -> ( "Context", "Action number " ++ String.fromInt index ))
                    )
              )
            ]
        |> renderWithComponentList """
The UI for action logs is something I want to spend more time on.

For example, why do we even need a blank bar at the bottom of the book unless we actually log something? We can do some fun stuff with animation so it's more entertaining to see actions happen on ElmBooks. Lots of opportunities here!

Anyway… it works for now! 🙂
"""
