module ElmBook.UI.Docs.Header exposing (..)

import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (Chapter, chapter, renderComponentList, withComponentOptions)
import ElmBook.ComponentOptions
import ElmBook.Internal.Theme exposing (defaultTheme)
import ElmBook.ThemeOptions
import ElmBook.UI.Header exposing (view)
import ElmBook.UI.Helpers exposing (themeBackground)
import ElmBook.UI.Icons exposing (iconElm)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


docs : Chapter x
docs =
    let
        props =
            { href = "/logAction/href"
            , title = "Title"
            , theme = defaultTheme
            , isMenuOpen = False
            , onClickHeader = logAction "onClickHeader"
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
        |> withComponentOptions
            [ ElmBook.ComponentOptions.background themeBackground
            ]
        |> renderComponentList
            [ ( "Default"
              , view props
              )
            , ( "Custom Logo"
              , view
                    { props
                        | theme =
                            ElmBook.ThemeOptions.logo
                                (iconElm { size = 28, color = "#75c5f0" })
                                props.theme
                    }
              )
            , ( "Custom"
              , view
                    { props
                        | theme =
                            ElmBook.ThemeOptions.header
                                customTitle
                                props.theme
                    }
              )
            ]
