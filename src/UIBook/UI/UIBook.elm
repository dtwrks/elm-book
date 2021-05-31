module UIBook.UI.UIBook exposing (..)

import ElmBook exposing (withChapterGroups, withSubtitle)
import UIBook.ElmCSS exposing (UIBook, book)
import UIBook.UI.Docs.ActionLog
import UIBook.UI.Docs.Footer
import UIBook.UI.Docs.Guides.LoggingActions
import UIBook.UI.Docs.Guides.StatefulChapters
import UIBook.UI.Docs.Guides.Theming
import UIBook.UI.Docs.Header
import UIBook.UI.Docs.Icons
import UIBook.UI.Docs.Intro.Overview
import UIBook.UI.Docs.Markdown
import UIBook.UI.Docs.Nav
import UIBook.UI.Docs.Search
import UIBook.UI.Docs.Wrapper


main : UIBook ()
main =
    book "UIBook" ()
        |> withSubtitle "Documentation"
        |> withChapterGroups
            [ ( "", [ UIBook.UI.Docs.Intro.Overview.docs ] )
            , ( "Guides"
              , [ UIBook.UI.Docs.Guides.Theming.docs
                , UIBook.UI.Docs.Guides.LoggingActions.docs
                , UIBook.UI.Docs.Guides.StatefulChapters.docs
                ]
              )
            , ( "Private Components"
              , [ UIBook.UI.Docs.Wrapper.docs
                , UIBook.UI.Docs.Header.docs
                , UIBook.UI.Docs.Search.docs
                , UIBook.UI.Docs.Nav.docs
                , UIBook.UI.Docs.Footer.docs
                , UIBook.UI.Docs.ActionLog.docs
                , UIBook.UI.Docs.Icons.docs
                , UIBook.UI.Docs.Markdown.docs
                ]
              )
            ]
