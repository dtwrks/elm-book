module UIBook.UI.Wrapper exposing (view)

import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import UIBook.UI.Helpers exposing (..)



-- View


view :
    { themeBackground : String
    , themeBackgroundAlt : String
    , themeAccent : String
    , themeAccentAlt : String
    , globals : List (Html msg)
    , header : Html msg
    , menu : Html msg
    , menuHeader : Html msg
    , menuFooter : Html msg
    , main : Html msg
    , mainHeader : Maybe (Html msg)
    , mainFooter : Html msg
    , modal : Maybe (Html msg)
    , isMenuOpen : Bool
    , onCloseModal : msg
    }
    -> Html msg
view props =
    div [ setTheme props.themeBackground props.themeBackgroundAlt props.themeAccent props.themeAccentAlt ]
        [ div [ css [ display none ] ] props.globals
        , node "style"
            []
            [ text """
@import url('https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;600&family=IBM+Plex+Sans:wght@300;400;600&family=IBM+Plex+Serif:ital,wght@0,400;0,600;1,400;1,600&display=swap');

@keyframes fade-in {
  from { opacity: 0; }
  to   { opacity: 1; }
}

.ui-book-fade-in {
    animation: 0.3s linear fade-in;
}
            """
            ]
        , div
            [ css
                [ insetZero
                , displayFlex
                , alignItems stretch
                , mobile
                    [ flexDirection column
                    ]
                ]
            , style "background" themeBackground
            ]
            [ -- Sidebar
              div
                [ css
                    [ displayFlex
                    , flexDirection column
                    , Css.width (px sidebarSize)
                    , mobile
                        [ Css.width (pct 100)
                        ]
                    ]
                , if props.isMenuOpen then
                    css [ mobile [ flexGrow (num 1) ] ]

                  else
                    css []
                ]
                [ -- Header
                  div
                    [ css [ padding (px 8), paddingBottom (px 4) ]
                    ]
                    [ props.header ]
                , -- Menu
                  div
                    [ css
                        [ flexGrow (num 1)
                        , displayFlex
                        , flexDirection column
                        ]
                    , if props.isMenuOpen then
                        css [ mobile [ displayFlex ] ]

                      else
                        css [ mobile [ display none ] ]
                    ]
                    [ -- Menu Header
                      div
                        [ css [ padding (px 8) ]
                        ]
                        [ props.menuHeader ]
                    , div
                        [ style "opacity" "0.25"
                        , style "border-bottom" ("1px solid " ++ themeBackgroundAlt)
                        ]
                        []
                    , -- Menu Main
                      div
                        [ css
                            [ position relative
                            , flexGrow (num 1)
                            ]
                        ]
                        [ div
                            [ css
                                [ insetZero
                                , overflow auto
                                , padding2 (px 8) zero
                                ]
                            ]
                            [ props.menu
                            ]
                        ]
                    , -- Menu Footer
                      div
                        [ style "opacity" "0.25"
                        , style "border-bottom" ("1px solid " ++ themeBackgroundAlt)
                        ]
                        []
                    , div
                        [ css
                            [ padding (px 8)
                            ]
                        ]
                        [ props.menuFooter ]
                    ]
                ]
            , -- Main
              div
                [ css
                    [ flexGrow (num 1)
                    , displayFlex
                    , flexDirection column
                    , padding4 (px 8) (px 8) zero zero
                    , mobile [ paddingLeft (px 8) ]
                    ]
                , if props.isMenuOpen then
                    css [ mobile [ display none ] ]

                  else
                    css [ mobile [ displayFlex ] ]
                ]
                [ div
                    [ css
                        [ flexGrow (num 1)
                        , displayFlex
                        , flexDirection column
                        , backgroundColor (hex wrapperMainBackground)
                        , borderRadius4 (px 4) (px 4) zero zero
                        , overflow Css.hidden
                        ]
                    ]
                    [ -- Main Header
                      case props.mainHeader of
                        Just mainHeader ->
                            div
                                [ css [ borderBottom3 (px 1) solid (rgba 0 0 0 0.1) ] ]
                                [ mainHeader ]

                        Nothing ->
                            text ""
                    , -- Main Main
                      div
                        [ css
                            [ position relative
                            , flexGrow (num 1)
                            , padding2 (px 8) zero
                            ]
                        ]
                        [ div [ css [ insetZero, overflow auto ] ]
                            [ props.main ]
                        ]
                    , -- Main Footer
                      div
                        [ css
                            [ borderTop3 (px 1) solid (rgba 0 0 0 0.1)
                            ]
                        ]
                        [ props.mainFooter ]
                    ]
                ]
            ]
        , case props.modal of
            Just html ->
                div
                    [ class "ui-book-fade-in"
                    , css
                        [ insetZero
                        , displayFlex
                        , alignItems center
                        , justifyContent center
                        , zIndex (int modalZ)
                        ]
                    ]
                    [ div
                        [ onClick props.onCloseModal
                        , css
                            [ insetZero
                            , zIndex (int 0)
                            , backgroundColor (rgba 0 0 0 0.15)
                            , cursor pointer
                            , transition [ Css.Transitions.backgroundColor 300 ]
                            , hover [ backgroundColor (rgba 0 0 0 0.1) ]
                            ]
                        ]
                        []
                    , div
                        [ css
                            [ position relative
                            , zIndex (int 1)
                            , margin (px 40)
                            , maxHeight (calc (pct 100) minus (px 120))
                            , overflowY auto
                            , backgroundColor (hex "#fff")
                            , borderRadius (px 8)
                            , shadows
                            ]
                        ]
                        [ html ]
                    ]

            Nothing ->
                text ""
        ]



-- Helpers


sidebarSize : Float
sidebarSize =
    280


modalZ : Int
modalZ =
    99999
