module ElmBook.UI.Docs.Header exposing (..)

import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (Chapter, chapter, renderComponentList, withComponentOptions)
import ElmBook.Component
import ElmBook.Internal.Theme exposing (defaultTheme)
import ElmBook.Theme
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
            { href = "/x"
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
            [ ElmBook.Component.background themeBackground
            ]
        |> renderComponentList
            [ ( "Default"
              , view props
              )
            , ( "Custom Logo"
              , view
                    { props
                        | theme =
                            ElmBook.Theme.logo
                                (iconElm { size = 28, color = "#75c5f0" })
                                props.theme
                    }
              )
            , ( "Custom"
              , view
                    { props
                        | theme =
                            ElmBook.Theme.header
                                customTitle
                                props.theme
                    }
              )
            ]
