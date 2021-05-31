module UIBook.UI.Docs.Wrapper exposing (..)

import Css exposing (..)
import ElmBook exposing (chapter, withSections)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.ElmCSS exposing (UIChapter)
import UIBook.UI.Placeholder as Placeholder
import UIBook.UI.Wrapper exposing (view)


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
            , header = placeholder_
            , menuHeader = placeholder_
            , menu = placeholderList
            , menuFooter = placeholder_
            , mainHeader = Nothing
            , main = placeholderList
            , mainFooter = placeholder_
            , modal = Nothing
            , onCloseModal = ElmBook.logAction "onCloseModal"
            }

        wrapper child =
            div [ css [ Css.height (px 400), fontFamily sansSerif ] ] [ child ]
    in
    chapter "Wrapper"
        |> withSections
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


placeholderHeader_ : Html msg
placeholderHeader_ =
    Placeholder.custom
        |> Placeholder.withHeight 120
        |> Placeholder.view
        |> Html.Styled.fromUnstyled


placeholder_ : Html msg
placeholder_ =
    Placeholder.placeholder
        |> Html.Styled.fromUnstyled


placeholderList : Html msg
placeholderList =
    let
        placeholder__ =
            Placeholder.custom
                |> Placeholder.withForegroundColor "#fff"
                |> Placeholder.withBackgroundColor "#f0f"
                |> Placeholder.view
                |> Html.Styled.fromUnstyled

        item =
            div
                [ css [ padding (px 8) ] ]
                [ placeholder__
                ]

        items =
            List.repeat 40 item
    in
    ul
        [ css
            [ margin zero
            , padding zero
            , boxSizing borderBox
            , backgroundColor (rgba 0 0 0 0.1)
            ]
        ]
        items


mockModalContent : Html msg
mockModalContent =
    div
        [ css
            [ Css.width (px 400)
            ]
        ]
        [ placeholder_ ]
