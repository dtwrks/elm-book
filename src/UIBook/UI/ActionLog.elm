module UIBook.UI.ActionLog exposing (list, preview, previewEmpty)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import UIBook.UI.Helpers exposing (..)


item : Int -> ( String, String ) -> Html msg
item index ( context, label ) =
    div
        [ css
            [ displayFlex
            , alignItems baseline
            , padding2 (px 12) (px 20)
            , fontMonospace
            , fontSize (px 14)
            , backgroundColor (hex "#f3f3f3")
            ]
        ]
        [ span
            [ css
                [ display inlineBlock
                , paddingRight (px 16)
                , color (hex "#a0a0a0")
                ]
            ]
            [ text ("(" ++ String.fromInt (index + 1) ++ ")")
            ]
        , span
            [ css
                [ paddingRight (px 16)
                , color (hex "#a0a0a0")
                , letterSpacing (px 0.5)
                ]
            ]
            [ text context ]
        , span [] [ text label ]
        ]


preview :
    { lastActionIndex : Int
    , lastAction : ( String, String )
    , onClick : msg
    }
    -> Html msg
preview props =
    div
        [ css
            [ padding (px 8)
            ]
        ]
        [ button
            [ css
                [ border zero
                , borderRadius (px 4)
                , backgroundColor transparent
                , display block
                , Css.width (pct 100)
                , padding zero
                , margin zero
                , textAlign left
                , fontSize (rem 1)
                , cursor pointer
                , outline none
                , hover [ opacity (num 0.9) ]
                , active [ opacity (num 0.8) ]
                ]
            , onClick props.onClick
            ]
            [ item props.lastActionIndex props.lastAction
            ]
        ]


previewEmpty : Html msg
previewEmpty =
    div
        [ css
            [ fontMonospace
            , fontSize (px 14)
            , color (hex "#aaa")
            , padding (px 8)
            ]
        ]
        [ div
            [ css
                [ padding2 (px 12) (px 20)
                , backgroundColor (hex "#f3f3f3")
                , borderRadius (px 4)
                ]
            ]
            [ text "Your logged actions will appear here."
            ]
        ]


list : List ( String, String ) -> Html msg
list props =
    let
        docHeaderSize =
            34
    in
    div
        [ css
            [ position relative
            , paddingTop (px docHeaderSize)
            , Css.width (px 640)
            , maxWidth (pct 100)
            ]
        ]
        [ p
            [ css
                [ displayFlex
                , alignItems center
                , position absolute
                , top zero
                , left zero
                , right zero
                , Css.height (px docHeaderSize)
                , boxSizing borderBox
                , margin zero
                , padding2 zero (px 20)
                , fontLabel
                , fontWeight bold
                , color (hex "#fff")
                ]
            , style "background" themeBackground
            ]
            [ text "Action log" ]
        , ul
            [ css
                [ listStyle none
                , padding zero
                , margin zero
                , maxHeight (vh 70)
                , overflowY auto
                ]
            ]
            (List.indexedMap item props
                |> List.reverse
                |> List.map
                    (\item_ ->
                        li
                            [ css
                                [ borderTop3 (px 1) solid (hex "#f5f5f5")
                                ]
                            ]
                            [ item_ ]
                    )
            )
        ]
