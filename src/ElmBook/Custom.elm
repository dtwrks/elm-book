module ElmBook.Custom exposing
    ( Chapter
    , Msg
    , customBook
    )

import ElmBook.Internal.Book exposing (ElmBookBuilder(..))
import ElmBook.Internal.Chapter
import ElmBook.Internal.Component
import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.Theme exposing (defaultTheme)
import Html exposing (Html)


type alias Msg state =
    ElmBook.Internal.Msg.Msg state


type alias Chapter state html =
    ElmBook.Internal.Chapter.ChapterCustom state html


customBook : (html -> Html (Msg state)) -> String -> state -> ElmBookBuilder state html
customBook toHtml title initialState =
    ElmBookBuilder
        { urlPreffix = "chapter"
        , title = title
        , theme = defaultTheme
        , componentOptions = ElmBook.Internal.Component.defaultOptions
        , state = initialState
        , toHtml = toHtml
        , globals = Nothing
        }
