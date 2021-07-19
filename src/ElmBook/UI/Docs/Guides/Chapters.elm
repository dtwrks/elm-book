module ElmBook.UI.Docs.Guides.Chapters exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render)


docs : Chapter x
docs =
    chapter "Chapters"
        |> render """
Chapters are what books are made of. They can be library guides, component examples, design tokens showcases, you name it.

Creating them is quite simple, take a look at one used to display different variants of a Button component:

```elm
module UI.Button exposing (view, docs)


import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


view :
    { label : String
    , disabled : Bool
    , onClick : msg
    }
    -> Html msg
view props =
    button
        [ class "px-8 py-3 rounded-md bg-indigo-200"
        , disabled props.disabled
        , onClick props.onClick
        ]
        [ text props.label ]


docs : Chapter x
docs =
    let
        props =
            { label = "Click me!"
            , disabled = False
            , onClick = logAction "Clicked button!"
            }
    in
    chapter "Buttons"
        |> renderComponentList
            [ ( "Default", view props )
            , ( "Disabled", view { props | disabled = True } )
            ]

```

**Tip:** Since Elm has amazing [dead code elimination](https://elm-lang.org/news/small-assets-without-the-headache#dead-code-elimination) you don't need to worry about splitting your component examples from your source code. They can live side by side making your development experience much better!

---

## Markdown and embedded components

I dare you to name one single thing that doesn't get more interesting with some markdown sprinkled on it. Yeah, you can't! …right?

So lets add some markdown to our chapter and directly embed our components in it!


```elm
module UI.Button exposing (view, docs)


import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


view :
    { label : String
    , disabled : Bool
    , onClick : msg
    }
    -> Html msg
view props =
    button
        [ class "px-8 py-3 rounded-md bg-indigo-200"
        , disabled props.disabled
        , onClick props.onClick
        ]
        [ text props.label ]


docs : Chapter x
docs =
    let
        props =
            { label = "Click me!"
            , disabled = False
            , onClick = logAction "Clicked button!"
            }
    in
    chapter "Buttons"
        |> withComponentList
            [ ( "Default", view props )
            , ( "Disabled", view { props | disabled = True } )
            ]
        |> render \"\"\"
Buttons are pretty amazing, right? You can click them and stuff.

Try clicking on this one:

<component with-label="Default" />

They can also be disabled! Unbelievable.

<component with-label="Disabled" />
\"\"\"
```

---

If you want to create interactive chapters, take a look at the ["Stateful Chapters"](/guides/stateful-chapters) guide to know more.

This is not the only thing you can do with Chapters though! You can customize how each component is displayed and more. Take a look at [the docs](https://package.elm-lang.org/packages/dtwrks/elm-book/latest/) for the details.

"""
