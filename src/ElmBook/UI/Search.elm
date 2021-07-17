module ElmBook.UI.Search exposing
    ( styles
    , view
    )

import ElmBook.UI.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view :
    { value : String
    , onInput : String -> msg
    , onFocus : msg
    , onBlur : msg
    }
    -> Html msg
view props =
    div [ class "elm-book-wrapper elm-book-search-wrapper elm-book-sans" ]
        [ div [ class "elm-book-search-bg elm-book-inset" ]
            []
        , div [ class "elm-book-search-border elm-book-inset" ]
            []
        , input
            [ id "elm-book-search"
            , value props.value
            , onInput props.onInput
            , onFocus props.onFocus
            , onBlur props.onBlur
            , placeholder "Type \"⌘K\" to search…"
            ]
            []
        ]


styles : Html msg
styles =
    css_ <| """
.elm-book-search-wrapper {
    position: relative;
    width: 100%;
}

#elm-book-search {
    position: relative;
    z-index: 1;
    width: 100%;
    padding: 10px 12px;
    border: 0;
    border-radius: 4px;
    background: none;
    font-size: 14px;
    color: """ ++ themeAccent ++ """;
    transition: 0.2s;
}
#elm-book-search:focus {
    outline: none;
}
#elm-book-search::placeholder {
    border-radius: 4px;
    color: """ ++ themeNavAccent ++ """;
    opacity: 0.7;
}

.elm-book-search-bg {
    opacity: 0.2;
    border-radius: 4px;
    background-color: """ ++ themeNavBackground ++ """;
}
.elm-book-search-border {
    opacity: 0.5;
    border-radius: 4px;
    border: 0px solid """ ++ themeAccent ++ """;
    transition: 0.2s;
}

.elm-book-search-wrapper:hover .elm-book-search-bg {
    opacity: 0.25;
}
.elm-book-search-wrapper:hover .elm-book-search-border {
    border-width: 3px;
}
.elm-book-search-wrapper:focus-within .elm-book-search-border {
    opacity: 1;
    border-width: 3px;
}
"""
