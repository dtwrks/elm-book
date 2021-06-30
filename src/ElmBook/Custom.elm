module ElmBook.Custom exposing
    ( Chapter
    , Msg
    , customBook
    )

import ElmBook.Internal.ApplicationOptions
import ElmBook.Internal.Book exposing (ElmBookBuilder(..))
import ElmBook.Internal.Chapter
import ElmBook.Internal.Component
import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.Theme
import Html exposing (Html)


type alias Msg state =
    ElmBook.Internal.Msg.Msg state


type alias Chapter state html =
    ElmBook.Internal.Chapter.ChapterCustom state html


customBook : (html -> Html (Msg state)) -> String -> ElmBookBuilder state html
customBook toHtml title =
    ElmBookBuilder
        { title = title
        , theme = ElmBook.Internal.Theme.defaultTheme
        , application = ElmBook.Internal.ApplicationOptions.defaultOptions
        , componentOptions = ElmBook.Internal.Component.defaultOptions
        , toHtml = toHtml
        }
