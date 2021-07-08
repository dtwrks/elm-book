module ElmBook.UI.Docs.Guides.Interop exposing (docs)

import ElmBook.Chapter exposing (Chapter, chapter, render)


docs : Chapter x
docs =
    chapter "Elm-UI and Elm-CSS"
        |> render """
When building our UIs with Elm, we're lucky to have such awesome libraries to choose from such as [Elm-UI](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/), [Elm-CSS](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/), [Elm-Tailwind-Modules](https://package.elm-lang.org/packages/matheus23/elm-default-tailwind-modules/latest/), etc. So ElmBook is obviously compatible with all of them!

## Package approach

Since working with Elm-UI and Elm-CSS is so common we also provide two packages that can be used alongside ElmBook to make this process even simpler:

- [elm-book-interop-elm-ui](https://package.elm-lang.org/packages/dtwrks/elm-book-interop-elm-ui/latest/)
- [elm-book-interop-elm-css](https://package.elm-lang.org/packages/dtwrks/elm-book-interop-elm-css/latest/)

## Do it yourself

We enable you to work with any custom elements via the `ElmBook.Custom` module. Lets see how we would integrate Elm-UI and ElmBook ourselves:

```elm
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
```

After that you would only need to use this custom `book` function and `Book` type when creating a new book and the custom `Chapter` type when creating a new chapter. Simple as that.

"""
