module UIBook.UI.Footer exposing (view)

import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.UI.Helpers exposing (..)
import UIBook.UI.Icons exposing (..)


view : Html msg
view =
    a
        [ href "https://package.elm-lang.org/packages/dtwrks/elm-ui-book/latest/"
        , Html.Styled.Attributes.target "_blank"
        , css
            [ displayFlex
            , alignItems center
            , Css.width (pct 100)
            , margin zero
            , padding3 (px 11) (px 12) (px 12)
            , textDecoration none
            , opacity (num 0.8)
            , transition [ Css.Transitions.opacity 200 ]
            , hover [ opacity (num 1) ]
            ]
        , style "color" themeAccentAlt
        ]
        [ iconElm { size = 16, color = "currentColor" }
        , div
            [ css
                [ paddingLeft (px 8)
                , fontDefault
                , color currentColor
                , fontSize (px 10)
                , textTransform uppercase
                , letterSpacing (px 0.5)
                ]
            ]
            [ text "dtwrks/elm-ui-docs" ]
        ]
