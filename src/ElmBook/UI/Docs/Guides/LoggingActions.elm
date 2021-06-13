module ElmBook.UI.Docs.Guides.LoggingActions exposing (..)

import ElmBook exposing (UIChapter, chapter, renderElements, withElement)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : UIChapter x
docs =
    chapter "Logging Actions"
        |> withElement (text "Work in progress…")
        |> renderElements
