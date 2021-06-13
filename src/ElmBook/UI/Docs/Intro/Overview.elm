module ElmBook.UI.Docs.Intro.Overview exposing (..)

import ElmBook exposing (UIChapter, chapter, renderElements, withElement)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : UIChapter x
docs =
    chapter "Overview"
        |> withElement (text "Work in progress…")
        |> renderElements
