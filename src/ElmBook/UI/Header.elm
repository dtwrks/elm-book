module ElmBook.UI.Header exposing
    ( styles
    , view
    )

import ElmBook.Internal.ThemeOptions
import ElmBook.UI.Helpers exposing (..)
import ElmBook.UI.Icons exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.elm-book-header--link {
    display: block;
    padding: 8px 12px;
    text-decoration: none;
}
.elm-book-header--link:hover {
    opacity: 0.9;
}
.elm-book-header--link:active {
    opacity: 0.8;
}

.elm-book-header--button {
    display: none;
    padding: 12px;
    border: none;
    border-radius: 4px;
    box-shadow: none;
    background-color: transparent;
    cursor: pointer;
}
.elm-book-header--button:hover {
    opacity: 0.9;
    background-color: rgba(255, 255, 255, 0.1);
}
.elm-book-header--button:active {
    opacity: 0.4;
}
@media screen and (max-width: 768px) {
    .elm-book-header--button {
        display: flex;
        align-items: center;
    }
}

.elm-book-header-default {
    display: flex;
    align-items: center;
}

.elm-book-header-default--wrapper {
    display: block;
    padding-left: 16px;
    font-weight: 600;
    font-size: 16px;
}

.elm-book-header-default--title {
    display: block;
    padding-right: 4px;
}

.elm-book-header-default--subtitle {
    display: block;
    font-weight: 400;
}
"""


view :
    { href : String
    , toHtml : html -> Html msg
    , theme : ElmBook.Internal.ThemeOptions.ThemeOptions html
    , title : String
    , isMenuOpen : Bool
    , onClickHeader : msg
    , onClickMenuButton : msg
    }
    -> Html msg
view props =
    header
        [ class "elm-book-header" ]
        [ a
            [ href props.href
            , class "elm-book-header--link"
            , style "color" themeAccent
            ]
            [ h1 [ class "elm-book" ]
                [ ElmBook.Internal.ThemeOptions.header props.theme
                    |> Maybe.map props.toHtml
                    |> Maybe.withDefault
                        (viewDefault
                            { toHtml = props.toHtml
                            , href = props.href
                            , title = props.title
                            , theme = props.theme
                            }
                        )
                ]
            ]
        , button
            [ class "elm-book elm-book-header--button"
            , onClick props.onClickMenuButton
            ]
            [ if props.isMenuOpen then
                iconClose
                    { size = 20
                    , color = themeAccent
                    }

              else
                iconMenu
                    { size = 20
                    , color = themeAccent
                    }
            ]
        ]


viewDefault :
    { href : String
    , toHtml : html -> Html msg
    , title : String
    , theme : ElmBook.Internal.ThemeOptions.ThemeOptions html
    }
    -> Html msg
viewDefault props =
    span
        [ class "elm-book-sans elm-book-header-default" ]
        [ ElmBook.Internal.ThemeOptions.logo props.theme
            |> Maybe.map props.toHtml
            |> Maybe.withDefault
                (iconElm
                    { size = 24
                    , color = themeAccent
                    }
                )
        , span [ class "elm-book-header-default--wrapper" ]
            [ span
                [ class "elm-book-header-default--title" ]
                [ text props.title ]
            , ElmBook.Internal.ThemeOptions.subtitle props.theme
                |> Maybe.map
                    (\subtitle ->
                        span
                            [ class "elm-book-header-default--subtitle" ]
                            [ text subtitle ]
                    )
                |> Maybe.withDefault (text "")
            ]
        ]
