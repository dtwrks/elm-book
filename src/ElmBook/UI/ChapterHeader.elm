module ElmBook.UI.ChapterHeader exposing
    ( styles
    , view
    )

import ElmBook.UI.Helpers exposing (css_)
import ElmBook.UI.Icons exposing (iconDarkMode)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


styles : Html msg
styles =
    css_ """
.elm-book-chapter-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: 0;
    padding: 8px 12px 8px 16px;

}
.elm-book-dark-mode .elm-book-chapter-header {
    color: #dadada;
}

.elm-book-chapter-header__title {
    margin: 0;
    padding: 0;
    font-size: 12px;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #b0b4ba;
}
.elm-book-dark-mode .elm-book-chapter-header__title {
    color: #dadada;
}

.elm-book-chapter-header__btn {
    border: none;
    background: none;
    color: #b0b4ba;
}
.elm-book-chapter-header__btn:hover {
    cursor: pointer;
    opacity: 0.8;
}
.elm-book-chapter-header__btn:active {
    opacity: 0.6;
}
.elm-book-dark-mode .elm-book-chapter-header__btn {
    color: #dadada;
}
"""


view :
    { title : String
    , onToggleDarkMode : msg
    }
    -> Html msg
view props =
    div [ class "elm-book elm-book-chapter-header" ]
        [ p [ class "elm-book-chapter-header__title" ]
            [ text props.title ]
        , button
            [ class "elm-book-chapter-header__btn"
            , onClick props.onToggleDarkMode
            ]
            [ iconDarkMode
                { size = 16
                , color = "currentColor"
                }
            ]
        ]
