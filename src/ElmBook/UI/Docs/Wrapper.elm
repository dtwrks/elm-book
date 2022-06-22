module ElmBook.UI.Docs.Wrapper exposing (..)

import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (Chapter, chapter, renderWithComponentList, withComponentList)
import ElmBook.Internal.ThemeOptions exposing (defaultTheme)
import ElmBook.UI.Wrapper exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : Chapter x
docs =
    let
        props =
            { theme = defaultTheme
            , darkMode = False
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
            , onCloseModal = logAction "onCloseModal"
            }

        wrapper child =
            div [ style "height" "400px", style "position" "relative" ] [ child ]
    in
    chapter "Wrapper"
        |> withComponentList
            [ ( "Default"
              , wrapper (view props)
              )
            , ( "Opened Menu (Visible on Mobile)"
              , wrapper (view { props | isMenuOpen = True })
              )
            , ( "With Modal"
              , wrapper (view { props | modal = Just mockModalContent })
              )
            ]
        |> renderWithComponentList """
Since ElmBook is basically a "one layout" app – it's easier to maintain all its skeleton in a single place. This is all inside the `Wrapper` module. Take a look at the possible states below.

"""


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
