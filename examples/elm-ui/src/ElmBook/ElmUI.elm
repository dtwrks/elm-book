module ElmBook.ElmUI exposing (Book, Chapter, book)

import Element exposing (Element, layout)
import ElmBook.Custom exposing (customBook)


type alias Html state =
    Element (ElmBook.Custom.Msg state)


type alias BookBuilder state =
    ElmBook.Custom.BookBuilder state (Html state)


type alias Book state =
    ElmBook.Custom.Book state (Html state)


type alias Chapter state =
    ElmBook.Custom.Chapter state (Html state)


book : String -> BookBuilder state
book =
    customBook (layout [])
