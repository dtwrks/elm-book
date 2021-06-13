module ElmBook.UI.Docs.Wrapper exposing (..)

import ElmBook exposing (UIChapter, chapter, renderElements, withElements)
import ElmBook.UI.Wrapper exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : UIChapter x
docs =
    let
        props =
            { themeBackground = "#1293D8"
            , themeBackgroundAlt = "#1293D8"
            , themeAccent = "#fff"
            , themeAccentAlt = "#fff"
            , globals = []
            , isMenuOpen = False
            , header = placeholder True
            , menuHeader = placeholder True
            , menu = placeholderList True
            , menuFooter = placeholder True
            , mainHeader = Nothing
            , main = placeholderList False
            , mainFooter = placeholder False
            , modal = Nothing
            , onCloseModal = ElmBook.logAction "onCloseModal"
            }

        wrapper child =
            div [ style "height" "400px", style "position" "relative" ] [ child ]
    in
    chapter "Wrapper"
        |> withElements
            [ ( "Default"
              , wrapper (view props)
              )
            , ( "Opened Menu (Mobile)"
              , wrapper (view { props | isMenuOpen = True })
              )
            , ( "With Modal"
              , wrapper (view { props | modal = Just mockModalContent })
              )
            ]
        |> renderElements


placeholder : Bool -> Html msg
placeholder isLight =
    let
        backgroundColor =
            if isLight then
                "rgba(255, 255, 255, 0.2)"

            else
                "rgba(0, 0, 0, 0.1)"
    in
    div [ style "height" "40px", style "background" backgroundColor ] []


placeholderList : Bool -> Html msg
placeholderList isLight =
    let
        item =
            div
                [ style "padding" "8px" ]
                [ placeholder isLight ]

        items =
            List.repeat 40 item
    in
    ul
        [ style "margin" "0"
        , style "padding" "0"
        , style "width" "100%"
        , style "box-sizing" "border-box"
        ]
        items


mockModalContent : Html msg
mockModalContent =
    div [ style "width" "400px" ]
        [ placeholder False ]
