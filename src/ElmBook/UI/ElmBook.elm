module ElmBook.UI.ElmBook exposing (..)

import ElmBook exposing (ElmBook, book, withChapterGroups, withSubtitle)
import ElmBook.UI.Docs.ActionLog
import ElmBook.UI.Docs.Footer
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


main : ElmBook ()
main =
    book "ElmBook" ()
        |> withSubtitle "Documentation"
        |> withChapterGroups
            [ ( "", [ ElmBook.UI.Docs.Intro.Overview.docs ] )
            , ( "Guides"
              , [ ElmBook.UI.Docs.Guides.Theming.docs
                , ElmBook.UI.Docs.Guides.LoggingActions.docs
                , ElmBook.UI.Docs.Guides.StatefulChapters.docs
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
