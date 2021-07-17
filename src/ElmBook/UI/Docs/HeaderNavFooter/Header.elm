module ElmBook.UI.Docs.HeaderNavFooter.Header exposing (docs)

import ElmBook
import ElmBook.Actions exposing (logAction)
import ElmBook.Internal.ThemeOptions exposing (defaultTheme)
import ElmBook.ThemeOptions
import ElmBook.UI.Header exposing (view)
import ElmBook.UI.Icons exposing (iconElm)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


docs : List ( String, Html (ElmBook.Msg x) )
docs =
    let
        props =
            { toHtml = identity
            , href = "/logAction/href"
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
    [ ( "Header"
      , view props
      )
    , ( "Header w. Custom Logo"
      , view
            { props
                | theme =
                    ElmBook.ThemeOptions.logo
                        (iconElm { size = 28, color = "#75c5f0" })
                        props.theme
            }
      )
    , ( "Header w. Custom Content"
      , view
            { props
                | theme =
                    ElmBook.ThemeOptions.header
                        customTitle
                        props.theme
            }
      )
    ]
