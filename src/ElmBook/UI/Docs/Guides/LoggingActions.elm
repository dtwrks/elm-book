module ElmBook.UI.Docs.Guides.LoggingActions exposing (..)

import ElmBook exposing (UIChapter, chapter, logAction, logActionWithString, render, withElements)
import ElmBook.UI.Helpers exposing (css_)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


docs : UIChapter x
docs =
    chapter "Logging Actions"
        |> withElements
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
# Logging Actions

When creating something like a UI catalogue it's often useful to display how each element reacts to user interaction.

For instance, a custom button might receive an `onClick` message. But is that message actually sent when the user clicks on it? And what message should I use on my docs since the button can be used anywhere?

---

### Introducing `logAction`

ElmBook provides this function to help on those scenarios. It receives a label and it will print out your message (with it's context) whenever it is called. Try it out below:

<element with-label="button" />

```elm
chapter "button"
    |> withElement (
        myButton {
            onClick = logAction "Clicked button!"
        }
    )
```

---

### What about actions with parameters?

Sometimes your actions might not be as simple a button click – maybe your component sends some information along with the message?

Let's try it out with a text input – it sends out a message with the string the user typed in:

<element with-label="input" />

```elm
chapter "button"
    |> withElement (
        myInput {
            onInput =
                logActionWithString
                    "Received input with some value"
        }
    )
```

---

There are other `logAction*` functions available. Check out the docs!

"""
