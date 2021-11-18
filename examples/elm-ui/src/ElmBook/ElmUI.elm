module ElmBook.ElmUI exposing (Book, Chapter, book)

import Element exposing (Element, layout)
import ElmBook.Custom exposing (customBook)


type alias Html state subMsg =
    Element (ElmBook.Custom.Msg state subMsg)


type alias BookBuilder state subMsg =
    ElmBook.Custom.BookBuilder state (Html state subMsg) subMsg


type alias Book state subMsg =
    ElmBook.Custom.Book state (Html state subMsg) subMsg


type alias Chapter state subMsg =
    ElmBook.Custom.Chapter state (Html state subMsg)


book : String -> BookBuilder state subMsg
book =
    customBook (layout [])
