module ElmBook.UI.Styles exposing (view)

import ElmBook.UI.ActionLog
import ElmBook.UI.Chapter
import ElmBook.UI.ChapterComponent
import ElmBook.UI.ChapterHeader
import ElmBook.UI.Footer
import ElmBook.UI.Header
import ElmBook.UI.Helpers
import ElmBook.UI.Markdown
import ElmBook.UI.Nav
import ElmBook.UI.Search
import ElmBook.UI.Wrapper
import Html exposing (Html, div)


view : Html msg
view =
    div []
        [ ElmBook.UI.Helpers.baseStyles
        , ElmBook.UI.ActionLog.styles
        , ElmBook.UI.Chapter.styles
        , ElmBook.UI.ChapterComponent.styles
        , ElmBook.UI.ChapterHeader.styles
        , ElmBook.UI.Footer.styles
        , ElmBook.UI.Header.styles
        , ElmBook.UI.Markdown.styles
        , ElmBook.UI.Nav.styles
        , ElmBook.UI.Search.styles
        , ElmBook.UI.Wrapper.styles
        ]
