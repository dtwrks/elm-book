module ElmBook.UI.Docs.Guides.Books exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render)


docs : Chapter x
docs =
    chapter "Books"
        |> render """
After creating a few chapters, it's time to put your book together.

```elm
module MyBook exposing (main)


import ElmBook exposing (..)
import FirstChapter exposing (firstChapter)
import SecondChapter exposing (secondChapter)


main : Book ()
main =
    book "My Book"
        |> withChapters
            [ firstChapter
            , secondChapter
            ]
```

---

## Grouping Chapters

Let's make it more organized by grouping chapters into guides and component documentations.

```elm
module MyBook exposing (main)


import ElmBook exposing (..)
...

main : Book ()
main =
    book "My Book"
        |> withChapterGroups
            [ ( "Guides"
              , [ gettingStarted
                , secondGuide
                ]
              )
            , ( "Components"
              , [ buttons
                , forms
                , charts
                ]
              )
            ]
```

---

## Customizing your book

There are a few ways to customize your book:

- Make it interactive (we call those "stateful" books). Check the ["Stateful Chapters"](/guides/stateful-chapters) guide for more info.
- Customize its visual features (colors, header, ...). See the ["Theming"](/guides/theming) guide for more details.
- Customize the default visual features for components (hide component labels, make them full width, remove the card wrappers, ...). [Check the docs](https://package.elm-lang.org/packages/dtwrks/elm-book/latest/).

Each of those are accomplished using optional "attribute" functions. Similar to what you would see when using `Html.Attribute`. Take a look:

```elm
module MyBook exposing (main)


import ElmBook exposing (..)
import ElmBook.StatefulOptions
import ElmBook.Theme
import ElmBook.Component
...


main : Book SharedState
main =
    book "My Book"
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.globals [ resetCss ]
            , ElmBook.StatefulOptions.initialState initialSharedState
            ]
        |> withThemeOptions
            [ ElmBook.ThemeOptions.background "yellow"
            , ElmBook.ThemeOptions.subtitle "Guides & Stuff"
            ]
        |> withComponentOptions
            [ ElmBook.Component.background "black"
            ]
        |> withChapters
            [ ... ]
```

"""
