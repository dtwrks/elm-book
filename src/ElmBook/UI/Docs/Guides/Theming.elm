module ElmBook.UI.Docs.Guides.Theming exposing (docs)

import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (Chapter, chapter, render, withComponentList, withComponentOptions, withStatefulComponentList)
import ElmBook.ComponentOptions
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.ThemeOptions exposing (defaultTheme)
import ElmBook.ThemeOptions
import ElmBook.UI.Header
import ElmBook.UI.Helpers exposing (themeBackground)
import ElmBook.UI.Icons exposing (iconElm)
import ElmBook.UI.ThemeGenerator
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


docs : Chapter (ElmBook.UI.ThemeGenerator.SharedState m)
docs =
    let
        headerProps =
            { href = "/logAction/"
            , toHtml = identity
            , theme =
                defaultTheme
                    |> ElmBook.ThemeOptions.subtitle "Custom Subtitle"
            , title = "Custom Title"
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
            [ ElmBook.ComponentOptions.background themeBackground
            ]
        |> withComponentList
            [ ( "Header with custom logo"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.ThemeOptions.logo
                                (iconElm { size = 28, color = "#75c5f0" })
                                headerProps.theme
                    }
              )
            , ( "Custom header"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.ThemeOptions.header
                                customHeader
                                headerProps.theme
                    }
              )
            ]
        |> withStatefulComponentList
            [ ( "Theme Builder", ElmBook.UI.ThemeGenerator.view ) ]
        |> render ("""
Your book should look and feel your own, so ElmBook provides a few ways you can customize it's theme.

## Custom Header

You can choose a different logo, title and subtitle for your book:

<component with-label="Header with custom logo" with-background=\"""" ++ themeBackground ++ """" />

    main : Book x
    main =
        book "Custom Title"
            |> withThemeOptions
                [ ElmBook.ThemeOptions.subtitle "Custom Subtitle",
                , ElmBook.ThemeOptions.logo (img [ src "/mycompanylogo.png" ] [])
                ]
            |> withChapters []

Or you can go full custom and provide your own thing:

<component with-label="Custom header" with-background=\"""" ++ themeBackground ++ """" />

```elm
main : Book x
main =
    book "Custom Header"
        |> withThemeOptions
            [ ElmBook.ThemeOptions.header myCustomHeader
            ]
        |> withChapters []


myCustomHeader : Html msg
myCustomHeader =
    ...
```       

---

## Custom Colors

I mean… we all love Elm's light blue but maybe it doesn't fit your book. Don't fret, you can customize a lot of what you're seeing.

<component with-label="Theme Builder" />

    main : Book x
    main =
        book "CustomHeader"
            |> withThemeOptions
                [ ElmBook.ThemeOptions.background "slategray"
                , ElmBook.ThemeOptions.accent "white"
                ]
            |> withChapters [] 
---

## Dark Mode

Are you goth? Do you like the dark arts? Then tell your book so and it will always start already in dark mode:

    main : Book x
    main =
        book "Goth Book"
            |> withThemeOptions
                [ ElmBook.ThemeOptions.darkMode
                ]
            |> withChapters [] 

Don't worry… the light-theme losers can turn it off quite easily.

---

## Roadmap

The state of our dark mode setup right now is not that great. It's more like a book thing than a "per user" setting since we can't persist what the user selected using pure elm.

There is a plan to also enable custom fonts soon. Other than that, I believe changes will be less customizable and will focus more on a better UX for all ElmBooks.

Things like ready-to-be-used components like Placeholders, Design Tokens Catalogue, etc, should be handled by separate packages.

""")
