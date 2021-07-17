module ElmBook.Custom exposing (Book, BookBuilder, Chapter, Msg, customBook)

{-| Use this module to integrate other rendering engines to ElmBook such as Elm-UI and Elm-CSS. Lets see how we would integrate Elm-UI and ElmBook:

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
type alias Msg state =
    ElmBook.Internal.Msg.Msg state


{-| -}
type alias Chapter state html =
    ElmBook.Internal.Chapter.ChapterCustom state html


{-| -}
type alias BookBuilder state html =
    ElmBook.Internal.Book.BookBuilder state html


{-| -}
type alias Book state html =
    BookApplication state html


{-| -}
customBook : (html -> Html (Msg state)) -> String -> BookBuilder state html
customBook toHtml title =
    BookBuilder
        { title = title
        , toHtml = toHtml
        , themeOptions = ElmBook.Internal.ThemeOptions.defaultTheme
        , statefulOptions = ElmBook.Internal.StatefulOptions.defaultOptions
        , chapterOptions = ElmBook.Internal.Chapter.defaultOptions
        , componentOptions = ElmBook.Internal.ComponentOptions.defaultOptions
        }
