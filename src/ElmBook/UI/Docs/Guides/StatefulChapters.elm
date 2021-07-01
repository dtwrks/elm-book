module ElmBook.UI.Docs.Guides.StatefulChapters exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : Chapter x
docs =
    chapter "Stateful Chapters"
        |> render """
Sometimes it's useful to display a complex component so people can understand how it works on an isolated environment, not only see their possible static states.

But how to accomplish this with Elm's static typing? Simply provide your own custom model that can be used and updated by your own components across all your chapters.

---

## The Shared Model

Each book has one "shared state" and it's your job to slice in the way that makes sense for your book.

Lets say we have two stateful chapters, one with an input and the other one with a counter.

Let's first define a simple model for the `InputChapter`:

```elm
module InputChapter exposing (Model, init)


type alias Model =
    { value : String
    }


init : Model
init =
    { value = ""
    }
```

Then another even simpler one for the `CounterChapter`:

```elm
module CounterChapter exposing (Model, init)


type alias Model = Int


init : Model
init = 0
```

Then, on your book, you put everything together like this:

```elm
module Book exposing (main)


import ElmBook exposing (..)
import ElmBook.Application
import CounterChapter
import InputChapter


type alias Model =
    { inputChapter : InputChapter.Model
    , counterChapter : CounterChapter.Model
    }


initialState : SharedState
initialState =
    { inputChapter = InputChapter.init
    , counterChapter = CounterChapter.init
    }


main : Book SharedState
main =
    book "Stateful Book"
        |> withApplicationOptions
            [ ElmBook.Application.initialState initialState
            ]
        |> withChapters [
            CounterChapter.chapter,
            InputChapter.chapter
        ]
```

---

## Using the Shared State

By now we have our shared state properly setup, but how can we actually use that on our chapters? Let's see!

You need to tell your chapter where its state is located in your book. You also need to tell it how to update that state. It's pretty simple:

```elm
module CounterChapter exposing (Model, init, chapter)


import ElmBook.Chapter exposing (Chapter, chapter, renderStatefulComponent)
import ElmBook.Actions exposing (updateState)


type alias Model = Int


type alias SharedState
    = { x | counterModel : Model }


updateSharedState : SharedState -> SharedState
updateSharedState x =
    { x | counterModel = x.counterModel + 1 }


chapter : Chapter SharedState
chapter =
    chapter "InputChapter"
        |> renderStatefulComponent (
            \\{ inputModel } ->
                myCounter
                    { value = inputModel.value
                    , onIncrease = updateState updateSharedState
                    }
        )
```

The same can be done for the InputChapter. But note that the `updateState` is replaced with `updateStateWith` now that it receives one parameter.

```elm
module InputChapter exposing (Model, init, chapter)


import ElmBook.Chapter exposing (Chapter, chapter, renderStatefulComponent)
import ElmBook.Actions exposing (updateStateWith)


type alias Model = { value : String }


type alias SharedState
    = { x | inputModel : Model }


updateSharedState : Int -> SharedState -> SharedState
updateSharedState value x =
    { x | inputModel = { value = value } }


chapter : ElmBook.Chapter SharedState
chapter =
    ElmBook.chapter "InputChapter"
        |> withStatefulComponent (
            \\{ inputModel } ->
                myInput
                    { value = inputModel.value
                    , onInput = updateStateWith updateSharedState
                    }
        )
```

---

### Nested Elm Architecture Example

Let's change our `InputChapter` so it now have it's own elm architecture.

```elm
module InputChapter exposing (Model, init, chapter)


import ElmBook.Chapter exposing (Chapter, chapter, renderStatefulComponent)
import ElmBook.Actions exposing (updateStateWith)


type alias Model = { value = String }


type Msg =
    UpdateValue String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateValue value ->
            { value = value }


view : Model -> Html Msg
view model =
    input [ value model.value, onInput UpdateValue ] []


type alias SharedState
    = { x | inputModel : Model }


updateSharedState : Msg -> SharedState -> SharedState
updateSharedState msg shared =
    { shared | inputModel = update msg shared.inputModel }


chapter : ElmBook.Chapter SharedState
chapter =
    ElmBook.chapter "InputChapter"
        |> withStatefulComponent (
            \\{ inputModel } ->
                view inputModel
                    |> Html.map (updateStateWith updateSharedState)
        )
```


"""
