module ElmBook.UI.Docs.Guides.StatefulChapters exposing (..)

import ElmBook exposing (UIChapter, chapter, renderElements, withElement)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : UIChapter x
docs =
    chapter "Stateful Chapters"
        |> withElement (text "Work in progress…")
        |> renderElements
