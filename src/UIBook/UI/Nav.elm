module UIBook.UI.Nav exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import UIBook.UI.Helpers exposing (..)
import Url.Builder


inlineStyles : String
inlineStyles =
    """
.elm-ui-book-nav-item-bg {
    opacity: 0;
}
.elm-ui-book-nav-item.pre-selected .elm-ui-book-nav-item-bg {
    opacity: 0.1;
}
.elm-ui-book-nav-item.active .elm-ui-book-nav-item-bg {
    opacity: 0.25;
}
.elm-ui-book-nav-item.active.pre-selected .elm-ui-book-nav-item-bg {
    opacity: 0.3;
}
.elm-ui-book-nav-item:hover .elm-ui-book-nav-item-bg {
    opacity: 0.15;
}
.elm-ui-book-nav-item:active .elm-ui-book-nav-item-bg {
    opacity: 0.1;
}
.elm-ui-book-nav-item.active:hover .elm-ui-book-nav-item-bg {
    opacity: 0.3;
}
.elm-ui-book-nav-item.active:active .elm-ui-book-nav-item-bg {
    opacity: 0.25;
}
"""


view :
    { preffix : String
    , active : Maybe String
    , preSelected : Maybe String
    , itemGroups : List ( String, List ( String, String ) )
    }
    -> Html msg
view props =
    let
        isEmpty : Bool
        isEmpty =
            props.itemGroups
                |> List.foldl (\( _, xs ) acc -> acc + List.length xs) 0
                |> (==) 0

        item : ( String, String ) -> Html msg
        item ( slug, label ) =
            li []
                [ a
                    [ class "elm-ui-book-nav-item"
                    , classList
                        [ ( "elm-ui-book-nav-item", True )
                        , ( "active", props.active == Just slug )
                        , ( "pre-selected", props.preSelected == Just slug )
                        ]
                    , href (Url.Builder.absolute [ props.preffix, slug ] [])
                    , css
                        [ position relative
                        , displayFlex
                        , margin zero
                        , padding zero
                        , fontDefault
                        , fontSize (px 14)
                        , letterSpacing (px 1)
                        , textDecoration none
                        , Css.focus [ outline none ]
                        ]
                    , style "color" themeAccent
                    , if props.active == Just slug then
                        style "opacity" "1"

                      else
                        style "opacity" "0.8"
                    ]
                    [ div
                        [ class "elm-ui-book-nav-item-bg"
                        , style "background-color" themeBackgroundAlt
                        , css [ insetZero ]
                        ]
                        []
                    , div
                        [ css
                            [ padding2 (px 8) (px 20)
                            , position relative
                            , zIndex (int 1)
                            ]
                        ]
                        [ text label ]
                    ]
                ]

        list : ( String, List ( String, String ) ) -> Html msg
        list ( title, items ) =
            if List.isEmpty items then
                text ""

            else
                div [ css [ paddingBottom (px 16) ] ]
                    [ if title == "" then
                        text ""

                      else
                        p
                            [ css
                                [ margin zero
                                , padding3 (px 12) (px 20) (px 8)
                                , fontDefault
                                , fontWeight bold
                                , fontSize (px 12)
                                , textTransform uppercase
                                , letterSpacing (px 0.5)
                                ]
                            , style "color" themeAccent
                            ]
                            [ text title ]
                    , ul
                        [ css
                            [ listStyle none
                            , padding zero
                            , margin zero
                            ]
                        ]
                        (node "style" [] [ text inlineStyles ]
                            :: List.map item items
                        )
                    ]
    in
    if isEmpty then
        p
            [ css
                [ fontDefault
                , margin zero
                , padding2 (px 12) (px 20)
                , opacity (num 0.6)
                ]
            , style "color" themeAccent
            ]
            [ text "No results." ]

    else
        nav []
            (List.map list props.itemGroups)
