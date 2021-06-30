module ElmBook.Custom exposing
    ( Builder
    , Chapter
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


type alias Builder state html =
    ElmBookBuilder state html


customBook : (html -> Html (Msg state)) -> String -> Builder state html
customBook toHtml title =
    ElmBookBuilder
        { title = title
        , theme = ElmBook.Internal.Theme.defaultTheme
        , application = ElmBook.Internal.ApplicationOptions.defaultOptions
        , componentOptions = ElmBook.Internal.Component.defaultOptions
        , toHtml = toHtml
        }
