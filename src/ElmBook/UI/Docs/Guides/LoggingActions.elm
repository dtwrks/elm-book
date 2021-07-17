module ElmBook.UI.Docs.Guides.LoggingActions exposing (..)

import ElmBook.Actions exposing (logAction, logActionWithString)
import ElmBook.Chapter exposing (Chapter, chapter, render, withComponentList, withComponentOptions)
import ElmBook.ComponentOptions
import ElmBook.UI.Helpers exposing (css_)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


docs : Chapter x
docs =
    chapter "Logging Actions"
        |> withComponentOptions
            [ ElmBook.ComponentOptions.hiddenLabel True ]
        |> withComponentList
            [ ( "button"
              , div []
                    [ css_ """
                        .logging-actions-button {
                            padding: 8px 20px;
                            border: 2px solid rgba(0,135,207,1);
                            border-radius: 2px;
                            background-color: rgba(0,135,207,0.5);
                            color: white;
                            font-size: 16px;
                            cursor: pointer;
                        }
                        .logging-actions-button:hover {
                            opacity: 0.8;
                        }
                        .logging-actions-button:active {
                            opacity: 0.6;
                        }
                    """
                    , button
                        [ class "logging-actions-button"
                        , onClick <| logAction "Clicked button!"
                        ]
                        [ text "Click me" ]
                    ]
              )
            , ( "input"
              , div []
                    [ css_ """
                        .logging-actions-input {
                            padding: 8px 20px;
                            border: 2px solid rgba(0,135,207,1);
                            border-radius: 2px;
                            background-color: white;
                            font-size: 16px;
                            cursor: pointer;
                        }
                    """
                    , input
                        [ class "logging-actions-input"
                        , onInput <| logActionWithString "Received input with some value"
                        , placeholder "Type something…"
                        ]
                        []
                    ]
              )
            ]
        |> render """
When creating something like a UI catalogue it's often useful to display how each component reacts to user interaction.

For instance, a custom button might receive an `onClick` message. But is that message actually sent when the user clicks on it? And what message should I use on my docs since the button can be used anywhere?

---

### Introducing `logAction`

ElmBook provides this function to help on those scenarios. It receives a label and it will print out your message (with it's context) whenever it is called. Try it out below:

<component with-label="button" />

```elm
import ElmBook.Actions exposing (logAction)


chapter "button"
    |> withComponent (
        myButton {
            onClick = logAction "Clicked button!"
        }
    )
```

---

### What about actions with parameters?

Sometimes your actions might not be as simple a button click – maybe your component sends some information along with the message?

Let's try it out with a text input – it sends out a message with the string the user typed in:

<component with-label="input" />

```elm
import ElmBook.Actions exposing (logActionWithString)


chapter "button"
    |> withComponent (
        myInput {
            onInput =
                logActionWithString
                    "Received input with some value"
        }
    )
```

---

### Logging url changes?

It's a real pain when we want to showcase a navigation link and when we click on it we're suddenly on some random page. This is why we have a somewhat hidden feature – any route changes that starts with `/logAction` will actually just log the url change intent!

Try it here! [/logAction/external-url](/logAction/external-url)

---

There are other `logAction*` functions available. Check out the [docs](https://package.elm-lang.org/packages/dtwrks/elm-book/latest/)!

"""
