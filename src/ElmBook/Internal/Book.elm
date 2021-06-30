module ElmBook.Internal.Book exposing
    ( ElmBookBuilder(..)
    , ElmBookConfig
    )

import ElmBook.Internal.Component exposing (ValidComponentOptions)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.Theme exposing (Theme)
import Html exposing (Html)


type alias ElmBookConfig state html =
    { urlPreffix : String
    , title : String
    , theme : Theme
    , componentOptions : ValidComponentOptions
    , state : state
    , toHtml : html -> Html (Msg state)
    , globals : Maybe (List html)
    }


{-| -}
type ElmBookBuilder state html
    = ElmBookBuilder (ElmBookConfig state html)
