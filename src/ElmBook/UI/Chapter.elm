module ElmBook.UI.Chapter exposing
    ( ChapterLayout(..)
    , styles
    , view
    )

import ElmBook.Msg exposing (Msg(..))
import ElmBook.UI.Helpers exposing (..)
import ElmBook.UI.Markdown
import Html exposing (..)
import Html.Attributes exposing (..)


type ChapterLayout
    = SingleColumn
    | TwoColumns


type alias Props state =
    { title : String
    , layout : ChapterLayout
    , body : String
    , elements : List ( String, Html.Html (Msg state) )
    }


styles : Html msg
styles =
    css_ """
.elm-book-chapter {
    padding: 22px 20px 0;
    width: 100%;
}
"""


view : Props state -> Html (Msg state)
view props =
    article
        [ class "elm-book elm-book-chapter" ]
        [ ElmBook.UI.Markdown.view
            props.title
            props.elements
            props.body
        ]
