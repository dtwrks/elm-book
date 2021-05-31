module UIBook.UI.Search exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import UIBook.UI.Helpers exposing (..)


inlineStyle : String
inlineStyle =
    """
#ui-book-search {
    transition: 0.2s;
}
#ui-book-search::placeholder {
    color: """ ++ themeAccent ++ """;
    opacity: 0.7;
}
.ui-book-search-bg {
    opacity: 0.2;
}
.ui-book-search-wrapper:hover .ui-book-search-bg {
    opacity: 0.25;
}
.ui-book-search-border {
    opacity: 0.5;
    border-width: 0px;
    transition: 0.2s;
}
.ui-book-search-wrapper:hover .ui-book-search-border {
    border-width: 3px;
}
.ui-book-search-wrapper:focus-within .ui-book-search-border {
    opacity: 1;
    border-width: 3px;
}
"""


view :
    { value : String
    , onInput : String -> msg
    , onFocus : msg
    , onBlur : msg
    }
    -> Html msg
view props =
    div [ class "ui-book-search-wrapper", css [ Css.width (pct 100), position relative ] ]
        [ node "style" [] [ text inlineStyle ]
        , div
            [ class "ui-book-search-bg"
            , style "background-color" themeBackgroundAlt
            , css [ insetZero, borderRadius (px 4) ]
            ]
            []
        , div
            [ class "ui-book-search-border"
            , style "border-color" themeBackgroundAlt
            , css [ insetZero, borderStyle solid, borderRadius (px 4) ]
            ]
            []
        , input
            [ id "ui-book-search"
            , value props.value
            , onInput props.onInput
            , onFocus props.onFocus
            , onBlur props.onBlur
            , placeholder "Type \"⌘K\" to search…"
            , style "color" themeAccent
            , css
                [ position relative
                , zIndex (int 1)
                , Css.width (pct 100)
                , margin zero
                , padding2 (px 10) (px 12)
                , border zero
                , borderRadius (px 4)
                , boxSizing borderBox
                , backgroundColor transparent
                , fontDefault
                , fontSize (px 14)
                , focus [ outline none ]
                ]
            ]
            []
        ]
