module ElmBook.UI.Docs.ThemeGenerator exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render, withStatefulComponent)
import ElmBook.UI.ThemeGenerator


docs : Chapter (ElmBook.UI.ThemeGenerator.SharedState m)
docs =
    chapter "Theme Generator"
        |> withStatefulComponent ElmBook.UI.ThemeGenerator.view
        |> render """
This is a special component that would only work inside the ElmBook package itself since it uses private messages for changing the theme dynamically.

<component />

**Note**: You don't need to use a gradient at all! Check out the [docs](https://package.elm-lang.org/packages/dtwrks/elm-book/latest/ElmBook-ThemeOptions) for all options.
"""
