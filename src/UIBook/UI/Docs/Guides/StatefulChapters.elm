module UIBook.UI.Docs.Guides.StatefulChapters exposing (..)

import Css exposing (..)
import ElmBook exposing (chapter, withSection)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.ElmCSS exposing (UIChapter)


docs : UIChapter x
docs =
    chapter "Stateful Chapters"
        |> withSection (text "Work in progress…")
