module ElmBook.Internal.Book exposing
    ( BookBuilder(..)
    , ElmBookConfig
    )

import ElmBook.Internal.Chapter exposing (ValidChapterOptions)
import ElmBook.Internal.ComponentOptions exposing (ValidComponentOptions)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.StatefulOptions exposing (StatefulOptions)
import ElmBook.Internal.ThemeOptions exposing (ThemeOptions)
import Html exposing (Html)


type alias ElmBookConfig state html =
    { title : String
    , toHtml : html -> Html (Msg state)
    , statefulOptions : StatefulOptions state
    , themeOptions : ThemeOptions html
    , chapterOptions : ValidChapterOptions
    , componentOptions : ValidComponentOptions
    }


{-| -}
type BookBuilder state html
    = BookBuilder (ElmBookConfig state html)
