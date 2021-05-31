module UIBook.UI.Header exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import UIBook.UI.Helpers exposing (..)
import UIBook.UI.Icons exposing (..)


view :
    { href : String
    , logo : Maybe (Html msg)
    , title : String
    , subtitle : String
    , custom : Maybe (Html msg)
    , isMenuOpen : Bool
    , onClickMenuButton : msg
    }
    -> Html msg
view props =
    header
        [ css
            [ displayFlex
            , alignItems center
            , justifyContent spaceBetween
            ]
        ]
        [ a
            [ href props.href
            , css
                [ display block
                , padding2 (px 8) (px 12)
                , textDecoration none
                , fontDefault
                , hover [ opacity (num 0.9) ]
                , active [ opacity (num 0.8) ]
                , mobile []
                ]
            , style "color" themeAccentAlt
            ]
            [ h1
                [ css
                    [ margin zero
                    , padding zero
                    ]
                ]
                [ case props.custom of
                    Just custom ->
                        custom

                    Nothing ->
                        span
                            [ css
                                [ displayFlex
                                , alignItems center
                                ]
                            ]
                            [ props.logo
                                |> Maybe.withDefault
                                    (iconElm
                                        { size = 28
                                        , color = themeAccentAlt
                                        }
                                    )
                            , span
                                [ css
                                    [ display block
                                    , paddingLeft (px 16)
                                    , fontWeight (int 600)
                                    , fontSize (px 16)
                                    ]
                                ]
                                [ span
                                    [ css
                                        [ display block
                                        , paddingRight (px 4)
                                        ]
                                    ]
                                    [ text props.title
                                    ]
                                , span
                                    [ css
                                        [ display block
                                        , fontWeight (int 400)
                                        ]
                                    ]
                                    [ text props.subtitle ]
                                ]
                            ]
                ]
            ]
        , button
            [ onClick props.onClickMenuButton
            , css
                [ display none
                , fontDefault
                , padding (px 12)
                , margin zero
                , border zero
                , borderRadius (px 4)
                , boxShadow none
                , backgroundColor transparent
                , cursor pointer
                , hover [ opacity (num 0.9), backgroundColor (rgba 255 255 255 0.1) ]
                , active [ opacity (num 0.4) ]
                , mobile [ displayFlex, alignItems center ]
                ]
            ]
            [ if props.isMenuOpen then
                iconClose { size = 20, color = "#fff" }

              else
                iconMenu { size = 20, color = "#fff" }
            ]
        ]
