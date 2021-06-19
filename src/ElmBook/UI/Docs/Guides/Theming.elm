module ElmBook.UI.Docs.Guides.Theming exposing (..)

import ElmBook exposing (UIChapter, chapter, logAction, render, themeBackground, withBackgroundColor, withElement, withElements, withTwoColumns)
import ElmBook.UI.Header
import ElmBook.UI.Helpers exposing (css_, themeAccentAlt, themeBackgroundAlt, wrapperMainBackground)
import ElmBook.UI.Icons exposing (iconElm)
import Html exposing (..)
import Html.Attributes exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book-docs__theming__theme {
    display: flex;
    align-items: stretch;
    padding: 16px;
}
"""


docs : UIChapter x
docs =
    let
        headerProps =
            { href = "/x"
            , logo = Nothing
            , title = "Title"
            , subtitle = "Subtitle"
            , custom = Nothing
            , isMenuOpen = False
            , onClickMenuButton = logAction "onClickMenuButton"
            }

        customHeader =
            div
                [ style "font-size" "28px"
                , style "color" "#75c5f0"
                ]
                [ text "Custom" ]
    in
    chapter "Theming"
        |> withTwoColumns
        |> withBackgroundColor themeBackground
        |> withElements
            [ ( "Header with custom logo"
              , ElmBook.UI.Header.view { headerProps | logo = Just (iconElm { size = 28, color = "#75c5f0" }) }
              )
            , ( "Custom header"
              , ElmBook.UI.Header.view { headerProps | custom = Just customHeader }
              )
            , ( "Theme Builder"
              , div [ class "elm-book-wrapper elm-book-sans elm-book-docs__theming__theme", style "background" themeBackground ]
                    [ styles
                    , div [ style "width" "40%" ]
                        [ p
                            [ style "color" themeAccentAlt
                            , style "padding" "20px"
                            ]
                            [ text "Theme Accent Alt"
                            , br [] []
                            , span
                                [ style "font-size" "12px"
                                , style "opacity" "0.8"
                                ]
                                [ text "(Theme Background)"
                                ]
                            ]
                        , div
                            [ style "position" "relative"
                            , style "margin" "8px 0"
                            ]
                            [ div
                                [ class "elm-book-inset"
                                , style "opacity" "0.2"
                                , style "background-color" themeBackgroundAlt
                                ]
                                []
                            , p
                                [ style "padding" "20px 48px 20px 20px"
                                , style "position" "relative"
                                , style "z-index" "1"
                                , style "color" themeAccentAlt
                                ]
                                [ text "Theme Accent"
                                , br [] []
                                , span
                                    [ style "font-size" "12px"
                                    , style "opacity" "0.8"
                                    ]
                                    [ text "(Theme Background Alt)"
                                    ]
                                ]
                            ]
                        ]
                    , div
                        [ style "width" "60%"
                        , style "border-radius" "4px"
                        , style "padding" "20px 32px"
                        , style "background-color" wrapperMainBackground
                        , class "elm-book-md"
                        ]
                        [ h1 [ class "elm-book-serif" ] [ text "Title" ]
                        , p [ class "elm-book-serif" ] [ text "Paragraph" ]
                        ]
                    ]
              )
            ]
        |> render """
# Theming

Your book should look and feel your own, so ElmBook provides a few ways you can customize it's theme.

## Custom Header

You can choose a different logo, title and subtitle for your book:

<element with-label="Header with custom logo" />

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []

---

Or you can go full custom and provide your own thing:

<element with-label="Custom header" />

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withCustomHeader myCustomHeader
            |> withChapters []

## Custom Colors

What about colors? I mean… we all love Elm's light blue but maybe it doesn't fit our book. But don't fret, you can customize a lot of what you're seeing.

<element with-label="Theme Builder" />

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []        
"""
