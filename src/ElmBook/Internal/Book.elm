module ElmBook.Internal.Book exposing
    ( ElmBookBuilder(..)
    , ElmBookConfig
    )

import ElmBook.Internal.ApplicationOptions exposing (ApplicationOptions)
import ElmBook.Internal.Component exposing (ValidComponentOptions)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.Theme exposing (Theme)
import Html exposing (Html)


type alias ElmBookConfig state html =
    { title : String
    , toHtml : html -> Html (Msg state)
    , application : ApplicationOptions state html
    , theme : Theme
    , componentOptions : ValidComponentOptions
    }


{-| -}
type ElmBookBuilder state html
    = ElmBookBuilder (ElmBookConfig state html)
