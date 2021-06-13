module ElmBook.UI.Docs.ActionLog exposing (..)

import ElmBook exposing (UIChapter, chapter, logAction, renderElements, withElements)
import ElmBook.UI.ActionLog exposing (list, preview)


docs : UIChapter x
docs =
    chapter "ActionLog"
        |> withElements
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
        |> renderElements
