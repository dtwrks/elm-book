module ElmBook.Custom exposing
    ( Book, Chapter, Msg, customBook
    , BookBuilder
    )

{-| Use this module to integrate other rendering engines to ElmBook such as Elm-UI and Elm-CSS. Lets see how we would integrate Elm-UI and ElmBook:

    module ElmBook.ElmUI exposing (Book, Chapter, book)

    import Element exposing (Element, layout)
    import ElmBook.Custom

    type alias Html state =
        Element (ElmBook.Custom.Msg state)

    type alias Chapter state =
        ElmBook.Custom.Chapter state (Html state)

    book : String -> ElmBook.Custom.Builder state (Html state)
    book =
        customBook (layout [])

After that you would only need to use this custom `book` function and `Book` type when creating a new book and the custom `Chapter` definition when creating a new chapter.

@docs Book, Builder, Chapter, Msg, customBook

-}

import ElmBook.Internal.Application exposing (BookApplication)
import ElmBook.Internal.ApplicationOptions
import ElmBook.Internal.Book exposing (BookBuilder(..))
import ElmBook.Internal.Chapter
import ElmBook.Internal.Component
import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.Theme
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
        , theme = ElmBook.Internal.Theme.defaultTheme
        , application = ElmBook.Internal.ApplicationOptions.defaultOptions
        , componentOptions = ElmBook.Internal.Component.defaultOptions
        , toHtml = toHtml
        }
