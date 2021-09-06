module ElmBook.UI.Docs.DarkModeComponents exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render, withStatefulComponent)
import Html exposing (..)
import Html.Attributes exposing (..)


type alias SharedState x =
    { x | darkMode : Bool }


docs : Chapter (SharedState x)
docs =
    chapter "Dark Components"
        |> withStatefulComponent
            (\{ darkMode } ->
                div [ class "elm-book elm-book-serif" ]
                    [ if darkMode then
                        div []
                            [ p
                                [ style "color" "#fff" ]
                                [ text "You found me!" ]
                            ]

                      else
                        p
                            [ style "color" "#999" ]
                            [ text "There is something hidden in the dark…" ]
                    ]
            )
        |> render """
If want to showcase your UI components and their dark mode variants in all their glory, take a look at the `onDarkModeChange` helper. Try changing the dark/light mode and look at the component below:

<component />

Here is how it works:

```elm
    type alias SharedState =
        { darkMode : Bool
        }


    initialState : SharedState
    initialState =
        { darkMode = False
        }


    book : Book SharedState
    book "MyApp"
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.initialState
                initialState
            , ElmBook.StatefulOptions.onDarkModeChange
                (\\darkMode state ->
                    { state | darkMode = darkMode }
                )
            ]
        |> withChapters []


    darkModeChapter : Chapter SharedState
    darkModeChapter =
        chapter "Dark Mode"
            |> renderStatefulComponent (
                \\{ darkMode } ->
                    if darkMode then
                        text "You found me!"
                    else
                        text "There is something hidden in the dark…"
            )
```

"""
