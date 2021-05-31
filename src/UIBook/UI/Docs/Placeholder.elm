module UIBook.UI.Docs.Placeholder exposing (..)

import ElmBook exposing (chapter, withSections)
import Html.Styled exposing (fromUnstyled)
import UIBook.ElmCSS exposing (UIChapter)
import UIBook.UI.Placeholder as Placeholder exposing (placeholder)


docs : UIChapter x
docs =
    chapter "Placeholder [WIP]"
        |> withSections
            [ ( "Default"
              , placeholder
                    |> fromUnstyled
              )
            , ( "With custom width"
              , Placeholder.custom
                    |> Placeholder.withWidth 500
                    |> Placeholder.view
                    |> fromUnstyled
              )
            , ( "With Custom Foreground Color"
              , Placeholder.custom
                    |> Placeholder.withForegroundColor "#FF0000"
                    |> Placeholder.view
                    |> fromUnstyled
              )
            , ( "With Custom Background and Foreground Colors"
              , Placeholder.custom
                    |> Placeholder.withForegroundColor "#FFF"
                    |> Placeholder.withBackgroundColor "#FF0000"
                    |> Placeholder.view
                    |> fromUnstyled
              )
            ]
