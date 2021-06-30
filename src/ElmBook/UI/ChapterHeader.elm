module ElmBook.UI.ChapterHeader exposing
    ( styles
    , view
    )

import ElmBook.UI.Helpers exposing (css_)
import Html exposing (..)
import Html.Attributes exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book-chapter-header {
    margin: 0;
    padding: 12px 16px;
    font-size: 14px;
    font-weight: bold;
    color: #333;
}
"""


view : String -> Html msg
view title_ =
    div [ class "elm-book" ]
        [ p [ class "elm-book-chapter-header" ]
            [ text title_ ]
        ]
