module ElmBook.ElmUI exposing (UIBook, UIChapter, book)

{-| When using [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/), use these as replacements for the same types and functions found on `UIBook`. Everything else should work just the same.

@docs UIBook, UIChapter, book

-}

import Element exposing (Element, layout)
import ElmBook


type alias UIBookHtml state =
    Element (ElmBook.UIBookMsg state)


{-| -}
type alias UIChapter state =
    ElmBook.UIChapterCustom state (UIBookHtml state)


{-| -}
type alias UIBook state =
    ElmBook.UIBookCustom state (UIBookHtml state)


{-| -}
book : String -> state -> ElmBook.UIBookBuilder state (UIBookHtml state)
book title state =
    ElmBook.customBook
        { title = title
        , state = state
        , toHtml = layout []
        }
