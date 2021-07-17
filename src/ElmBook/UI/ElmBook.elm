module ElmBook.UI.ElmBook exposing (..)

import ElmBook exposing (Book, book, withChapterGroups, withStatefulOptions, withThemeOptions)
import ElmBook.Chapter
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import ElmBook.UI.Docs.ActionLog
import ElmBook.UI.Docs.Footer
import ElmBook.UI.Docs.Guides.Books
import ElmBook.UI.Docs.Guides.BuiltinServer
import ElmBook.UI.Docs.Guides.Chapters
import ElmBook.UI.Docs.Guides.Interop
import ElmBook.UI.Docs.Guides.LoggingActions
import ElmBook.UI.Docs.Guides.StatefulChapters
import ElmBook.UI.Docs.Guides.Theming
import ElmBook.UI.Docs.Header
import ElmBook.UI.Docs.Icons
import ElmBook.UI.Docs.Intro.Overview
import ElmBook.UI.Docs.Markdown
import ElmBook.UI.Docs.Nav
import ElmBook.UI.Docs.Search
import ElmBook.UI.Docs.Wrapper


type alias SharedState =
    { theming : ElmBook.UI.Docs.Guides.Theming.Model }


initialState : SharedState
initialState =
    { theming = ElmBook.UI.Docs.Guides.Theming.init }


main : Book SharedState
main =
    book "ElmBook's"
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.initialState initialState
            ]
        |> withThemeOptions
            [ ElmBook.ThemeOptions.subtitle "Guides & Components"
            ]
        |> withChapterGroups
            [ ( ""
              , [ ElmBook.UI.Docs.Intro.Overview.docs
                , ElmBook.Chapter.chapterLink
                    { title = "API"
                    , url = "https://package.elm-lang.org/packages/dtwrks/elm-book/latest/"
                    }
                ]
              )
            , ( "Guides"
              , [ ElmBook.UI.Docs.Guides.Chapters.docs
                , ElmBook.UI.Docs.Guides.Books.docs
                , ElmBook.UI.Docs.Guides.Theming.docs
                , ElmBook.UI.Docs.Guides.LoggingActions.docs
                , ElmBook.UI.Docs.Guides.StatefulChapters.docs
                , ElmBook.UI.Docs.Guides.Interop.docs
                , ElmBook.UI.Docs.Guides.BuiltinServer.docs
                ]
              )
            , ( "Private Components"
              , [ ElmBook.UI.Docs.Wrapper.docs
                , ElmBook.UI.Docs.Header.docs
                , ElmBook.UI.Docs.Search.docs
                , ElmBook.UI.Docs.Nav.docs
                , ElmBook.UI.Docs.Footer.docs
                , ElmBook.UI.Docs.ActionLog.docs
                , ElmBook.UI.Docs.Icons.docs
                , ElmBook.UI.Docs.Markdown.docs
                ]
              )
            ]
