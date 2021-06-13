module ElmBook.UI.Docs.Header exposing (..)

import ElmBook exposing (UIChapter, chapter, logAction, renderElementsWithBackground, withBackgroundColor, withElements, withTwoColumns)
import ElmBook.UI.Header exposing (view)
import ElmBook.UI.Helpers exposing (themeBackground)
import ElmBook.UI.Icons exposing (iconElm)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


docs : UIChapter x
docs =
    let
        props =
            { href = "/x"
            , logo = Nothing
            , title = "Title"
            , subtitle = "Subtitle"
            , custom = Nothing
            , isMenuOpen = False
            , onClickMenuButton = logAction "onClickMenuButton"
            }

        customTitle =
            div
                [ style "font-size" "28px"
                , style "color" "#75c5f0"
                ]
                [ text "Custom" ]
    in
    chapter "Header"
        |> withBackgroundColor themeBackground
        |> withTwoColumns
        |> withElements
            [ ( "Default"
              , view props
              )
            , ( "Custom Logo"
              , view { props | logo = Just (iconElm { size = 28, color = "#75c5f0" }) }
              )
            , ( "Custom"
              , view { props | custom = Just customTitle }
              )
            ]
        |> renderElementsWithBackground themeBackground
