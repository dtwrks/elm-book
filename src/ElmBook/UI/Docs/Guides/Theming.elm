module ElmBook.UI.Docs.Guides.Theming exposing
    ( Model
    , docs
    , init
    , styles
    )

import ElmBook.Actions exposing (logAction, updateStateWith)
import ElmBook.Chapter exposing (Chapter, chapter, render, withComponentList, withComponentOptions, withStatefulComponentList)
import ElmBook.Component
import ElmBook.Internal.Theme exposing (defaultTheme)
import ElmBook.Theme
import ElmBook.UI.Header
import ElmBook.UI.Helpers exposing (css_, setTheme, themeAccent, themeBackground, wrapperMainBackground)
import ElmBook.UI.Icons exposing (iconElm)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book-docs__theming__theme {
    display: flex;
    align-items: stretch;
    padding: 16px;
}
"""


type alias Model =
    { themeBackgroundStart : String
    , themeBackgroundEnd : String
    , themeAccent : String
    }


type alias SharedModel x =
    { x | themingModel : Model }


init : Model
init =
    { themeBackgroundStart = "rgba(0,135,207,1)"
    , themeBackgroundEnd = "rgba(86,207,255,1)"
    , themeAccent = "#fff"
    }


docs : Chapter (SharedModel x)
docs =
    let
        headerProps =
            { href = "/x"
            , theme = defaultTheme
            , title = "Title"
            , isMenuOpen = False
            , onClickHeader = logAction "onClickHeader"
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
        |> withComponentOptions
            [ ElmBook.Component.background themeBackground
            ]
        |> withComponentList
            [ ( "Header with custom logo"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.Theme.logo
                                (iconElm { size = 28, color = "#75c5f0" })
                                headerProps.theme
                    }
              )
            , ( "Custom header"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.Theme.header
                                customHeader
                                headerProps.theme
                    }
              )
            ]
        |> withStatefulComponentList
            [ ( "Theme Builder"
              , \{ themingModel } ->
                    div
                        [ setTheme
                            ("linear-gradient(150deg, " ++ themingModel.themeBackgroundStart ++ " 0%, " ++ themingModel.themeBackgroundEnd ++ " 100%)")
                            themingModel.themeAccent
                        ]
                        [ div [ class "elm-book-wrapper elm-book-sans elm-book-docs__theming__theme", style "background" themeBackground ]
                            [ styles
                            , div [ style "width" "40%" ]
                                [ p
                                    [ style "color" themeAccent
                                    , style "padding" "20px"
                                    ]
                                    [ span [ style "font-weight" "bold" ]
                                        [ text "Theme Accent Alt"
                                        ]
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
                                        , style "background-color" themeAccent
                                        ]
                                        []
                                    , p
                                        [ style "padding" "20px 48px 20px 20px"
                                        , style "position" "relative"
                                        , style "z-index" "1"
                                        , style "color" themeAccent
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
                        , div []
                            [ p []
                                [ label [] [ text "theme background (start)" ]
                                , input
                                    [ type_ "color"
                                    , onInput <|
                                        updateStateWith
                                            (\c shared ->
                                                let
                                                    themingModel_ =
                                                        shared.themingModel
                                                in
                                                { shared
                                                    | themingModel =
                                                        { themingModel_
                                                            | themeBackgroundStart = c
                                                        }
                                                }
                                            )
                                    ]
                                    []
                                ]
                            , p []
                                [ label [] [ text "theme background (end)" ]
                                , input
                                    [ type_ "color"
                                    , onInput <|
                                        updateStateWith
                                            (\c shared ->
                                                let
                                                    themingModel_ =
                                                        shared.themingModel
                                                in
                                                { shared
                                                    | themingModel =
                                                        { themingModel_
                                                            | themeBackgroundEnd = c
                                                        }
                                                }
                                            )
                                    ]
                                    []
                                ]
                            , p []
                                [ label [] [ text "theme accent" ]
                                , input
                                    [ type_ "color"
                                    , onInput <|
                                        updateStateWith
                                            (\c shared ->
                                                let
                                                    themingModel_ =
                                                        shared.themingModel
                                                in
                                                { shared
                                                    | themingModel =
                                                        { themingModel_
                                                            | themeAccent = c
                                                        }
                                                }
                                            )
                                    ]
                                    []
                                ]
                            ]
                        ]
              )
            ]
        |> render ("""
Your book should look and feel your own, so ElmBook provides a few ways you can customize it's theme.

## Custom Header

You can choose a different logo, title and subtitle for your book:

<component with-label="Header with custom logo" with-background=\"""" ++ themeBackground ++ """" />

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []

---

Or you can go full custom and provide your own thing:

<component with-label="Custom header" with-background=\"""" ++ themeBackground ++ """" />

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withCustomHeader myCustomHeader
            |> withChapters []

## Custom Colors

What about colors? I mean… we all love Elm's light blue but maybe it doesn't fit our book. But don't fret, you can customize a lot of what you're seeing.

<component with-label="Theme Builder" />

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []        
""")
