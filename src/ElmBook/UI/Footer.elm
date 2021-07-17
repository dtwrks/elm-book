module ElmBook.UI.Footer exposing
    ( styles
    , view
    )

import ElmBook.UI.Helpers exposing (..)
import ElmBook.UI.Icons exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book-footer {
    display: flex;
    align-items: center;
    width: 100%;
    margin: 0;
    padding: 13px 12px 13px;
    opacity: 0.8;
    transition: opacity 200ms;
    text-decoration: none;
}
.elm-book-footer:hover {
    opacity: 1;
}

.elm-book-footer--text {
    padding-left: 12px;
    font-size: 10px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: currentColor;
}
"""


view : Html msg
view =
    div [ class "elm-book elm-book-sans" ]
        [ a
            [ href "https://package.elm-lang.org/packages/dtwrks/elm-book/latest/"
            , target "_blank"
            , class "elm-book-footer"
            , style "color" themeAccent
            ]
            [ iconElm { size = 16, color = "currentColor" }
            , div [ class "elm-book-footer--text" ]
                [ text "dtwrks/elm-book" ]
            ]
        ]
