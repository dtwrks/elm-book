module ElmBook.UI.ElmBook exposing (..)

import ElmBook exposing (Book, book, withChapterGroups, withStatefulOptions, withThemeOptions)
import ElmBook.Chapter
import ElmBook.Internal.ThemeOptions
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import ElmBook.UI.Docs.ActionLog
import ElmBook.UI.Docs.DarkModeComponents
import ElmBook.UI.Docs.Guides.Books
import ElmBook.UI.Docs.Guides.BuiltinServer
import ElmBook.UI.Docs.Guides.Chapters
import ElmBook.UI.Docs.Guides.Interop
import ElmBook.UI.Docs.Guides.LoggingActions
import ElmBook.UI.Docs.Guides.StatefulChapters
import ElmBook.UI.Docs.Guides.Theming
import ElmBook.UI.Docs.HeaderNavFooter
import ElmBook.UI.Docs.Icons
import ElmBook.UI.Docs.Intro.Overview
import ElmBook.UI.Docs.Markdown
import ElmBook.UI.Docs.ThemeGenerator
import ElmBook.UI.Docs.Wrapper


type alias SharedState =
    { darkMode : Bool
    , theming :
        { backgroundStart : String
        , backgroundEnd : String
        , accent : String
        , navBackground : String
        , navAccent : String
        , navAccentHighlight : String
        }
    }


initialState : SharedState
initialState =
    { darkMode = False
    , theming =
        { backgroundStart = ElmBook.Internal.ThemeOptions.defaultBackgroundStart
        , backgroundEnd = ElmBook.Internal.ThemeOptions.defaultBackgroundEnd
        , accent = ElmBook.Internal.ThemeOptions.defaultAccent
        , navBackground = ElmBook.Internal.ThemeOptions.defaultNavBackground
        , navAccent = ElmBook.Internal.ThemeOptions.defaultNavAccent
        , navAccentHighlight = ElmBook.Internal.ThemeOptions.defaultNavAccentHighlight
        }
    }


main : Book SharedState
main =
    book "ElmBook's"
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.initialState initialState
            , ElmBook.StatefulOptions.onDarkModeChange
                (\darkMode s -> { s | darkMode = darkMode })
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
            , ( "Design System"
              , [ ElmBook.UI.Docs.Wrapper.docs
                , ElmBook.UI.Docs.HeaderNavFooter.docs
                , ElmBook.UI.Docs.ActionLog.docs
                , ElmBook.UI.Docs.Icons.docs
                , ElmBook.UI.Docs.Markdown.docs
                , ElmBook.UI.Docs.DarkModeComponents.docs
                , ElmBook.UI.Docs.ThemeGenerator.docs
                ]
              )
            ]
