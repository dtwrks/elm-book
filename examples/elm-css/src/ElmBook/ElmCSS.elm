module ElmBook.ElmCSS exposing (Book, Chapter, book)

import ElmBook.Custom exposing (customBook)
import Html.Styled


type alias Html state subMsg =
    Html.Styled.Html (ElmBook.Custom.Msg state subMsg)


type alias BookBuilder state subMsg =
    ElmBook.Custom.BookBuilder state (Html state subMsg) subMsg


type alias Book state subMsg =
    ElmBook.Custom.Book state (Html state subMsg) subMsg


type alias Chapter state subMsg =
    ElmBook.Custom.Chapter state (Html state subMsg)


book : String -> BookBuilder state subMsg
book =
    customBook Html.Styled.toUnstyled
