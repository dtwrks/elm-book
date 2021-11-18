module ElmBook.Custom exposing (Book, BookBuilder, Chapter, Msg, customBook)

{-| Use this module to integrate other rendering engines to ElmBook such as Elm-UI and Elm-CSS. Lets see how we would integrate Elm-UI and ElmBook:

    module ElmBook.ElmUI exposing (Book, Chapter, book)

    import Element exposing (Element, layout)
    import ElmBook.Custom exposing (customBook)

    type alias Html state subMsg =
        Element (ElmBook.Custom.Msg state subMsg)

    type alias BookBuilder state subMsg =
        ElmBook.Custom.BookBuilder state (Html state) subMsg

    type alias Book state subMsg =
        ElmBook.Custom.Book state (Html state) subMsg

    type alias Chapter state =
        ElmBook.Custom.Chapter state (Html state)

    book : String -> BookBuilder state subMsg
    book =
        customBook (layout [])

After that you would only need to use this custom `book` function and `Book` type when creating a new book and the custom `Chapter` definition when creating a new chapter.

@docs Book, BookBuilder, Chapter, Msg, customBook

-}

import ElmBook.Internal.Application exposing (BookApplication)
import ElmBook.Internal.Book exposing (BookBuilder(..))
import ElmBook.Internal.Chapter
import ElmBook.Internal.ComponentOptions
import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.StatefulOptions
import ElmBook.Internal.ThemeOptions
import Html exposing (Html)


{-| -}
type alias Msg state subMsg =
    ElmBook.Internal.Msg.Msg state subMsg


{-| -}
type alias Chapter state html =
    ElmBook.Internal.Chapter.ChapterCustom state html


{-| -}
type alias BookBuilder state html subMsg =
    ElmBook.Internal.Book.BookBuilder state html subMsg


{-| -}
type alias Book state html subMsg =
    BookApplication state html subMsg


{-| -}
customBook : (html -> Html (Msg state subMsg)) -> String -> BookBuilder state html subMsg
customBook toHtml title =
    BookBuilder
        { title = title
        , toHtml = toHtml
        , themeOptions = ElmBook.Internal.ThemeOptions.defaultTheme
        , statefulOptions = ElmBook.Internal.StatefulOptions.defaultOptions
        , chapterOptions = ElmBook.Internal.Chapter.defaultOptions
        , componentOptions = ElmBook.Internal.ComponentOptions.defaultOptions
        }
