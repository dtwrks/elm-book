module ElmBook.ElmCSS exposing (Book, Chapter, book)

import ElmBook.Custom exposing (customBook)
import Html.Styled


type alias Html state =
    Html.Styled.Html (ElmBook.Custom.Msg state)


type alias BookBuilder state =
    ElmBook.Custom.BookBuilder state (Html state)


type alias Book state =
    ElmBook.Custom.Book state (Html state)


type alias Chapter state =
    ElmBook.Custom.Chapter state (Html state)


book : String -> BookBuilder state
book =
    customBook Html.Styled.toUnstyled
