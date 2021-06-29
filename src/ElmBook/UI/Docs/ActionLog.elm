module ElmBook.UI.Docs.ActionLog exposing (..)

import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (Chapter, chapter, renderComponentList, withComponentList)
import ElmBook.UI.ActionLog exposing (list, preview)


docs : Chapter x
docs =
    chapter "ActionLog"
        |> renderComponentList
            [ ( "Preview"
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
