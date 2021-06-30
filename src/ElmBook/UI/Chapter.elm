module ElmBook.UI.Chapter exposing
    ( styles
    , view
    )

import ElmBook.Internal.Component
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.UI.Helpers exposing (..)
import ElmBook.UI.Markdown
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Props state =
    { title : String
    , componentOptions : ElmBook.Internal.Component.ValidComponentOptions
    , body : String
    , components : List ( String, Html.Html (Msg state) )
    }


styles : Html msg
styles =
    css_ """
.elm-book-chapter {
    padding: 40px;
    width: 100%;
}
"""


view : Props state -> Html (Msg state)
view props =
    article
        [ class "elm-book elm-book-chapter" ]
        [ ElmBook.UI.Markdown.view
            props.title
            props.components
            props.componentOptions
            props.body
        ]
