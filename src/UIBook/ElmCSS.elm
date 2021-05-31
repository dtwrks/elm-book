module UIBook.ElmCSS exposing (UIBook, UIChapter, book)

{-| When using [elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest), use these as replacements for the same types and functions found on `UIBook`. Everything else should work just the same.

@docs UIBook, UIChapter, book

-}

import ElmBook
import Html.Styled exposing (Html, toUnstyled)


type alias UIBookHtml state =
    Html (ElmBook.UIBookMsg state)


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
        , toHtml = toUnstyled
        }
