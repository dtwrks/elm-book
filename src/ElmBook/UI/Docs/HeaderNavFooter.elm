module ElmBook.UI.Docs.HeaderNavFooter exposing (..)

import ElmBook.Actions exposing (logAction, logActionWithString)
import ElmBook.Chapter exposing (Chapter, chapter, render, withComponentList, withComponentOptions)
import ElmBook.ComponentOptions
import ElmBook.UI.Docs.HeaderNavFooter.Header
import ElmBook.UI.Docs.HeaderNavFooter.Nav
import ElmBook.UI.Footer
import ElmBook.UI.Helpers exposing (themeBackground)
import ElmBook.UI.Search


docs : Chapter x
docs =
    chapter "Header, Nav & Footer"
        |> withComponentOptions
            [ ElmBook.ComponentOptions.background themeBackground
            ]
        |> withComponentList
            (List.concat
                [ ElmBook.UI.Docs.HeaderNavFooter.Header.docs
                , ElmBook.UI.Docs.HeaderNavFooter.Nav.docs
                , [ ( "Footer", ElmBook.UI.Footer.view )
                  , ( "Search"
                    , ElmBook.UI.Search.view
                        { value = ""
                        , onInput = logActionWithString "onInput"
                        , onFocus = logAction "onFocus"
                        , onBlur = logAction "onBlur"
                        }
                    )
                  ]
                ]
            )
        |> render """

All components used for the navigation area of an ElmBook.

The way we're generating this page is actually pretty neat – we're using `component-list` tags and `with-label` to pull out all components with labels that start with a given string. This is how we're easily grouping all title and nav components together! 💡

## Header

<component-list with-label="Header" />

## Search

<component with-label="Search" />

## Nav

<component-list with-label="Nav" />

## Footer

<component with-label="Footer" />

"""
