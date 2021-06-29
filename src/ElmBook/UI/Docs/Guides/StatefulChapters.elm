module ElmBook.UI.Docs.Guides.StatefulChapters exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : Chapter x
docs =
    chapter "Stateful Chapters"
        |> render """
Sometimes it's useful to display a complex component so people can understand how it works on an isolated environment, not only see their possible static states.

But how to accomplish this with Elm's static typing? Simply provide your own custom model that can be used and updated by your own elements.

---

## The Shared Model

Each book has one "shared model" and it's your job to slice in the way that makes sense for your book.

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
import CounterChapter
import InputChapter

type alias Model =
    { inputChapter : InputChapter.Model
    , counterChapter : CounterChapter.Model
    }

initialModel : Model
initialModel =
    { inputChapter = InputChapter.init
    , counterChapter = CounterChapter.init
    }

main : ElmBook Model
main =
    book "Stateful Book" initialModel
        |> withChapters [
            CounterChapter.chapter,
            InputChapter.chapter
        ]
```

---

## Using the Shared Model

By now we have our shared model properly setup, but how can we actually use those models on our chapters? Let's see!

You need to tell your chapter where its state is located in your book. You also need to tell it how to update that state. It's pretty simple:

```elm
module CounterChapter exposing (Model, init, chapter)

import ElmBook exposing (updateState)

type alias Model = Int

type alias SharedModel
    = { x | counterModel : Model }

updateSharedModel : SharedModel -> SharedModel
updateSharedModel x =
    { x | counterModel = x.counterModel + 1 }

chapter : ElmBook.Chapter SharedModel
chapter =
    ElmBook.chapter "InputChapter"
        |> withStatefulElement (
            \\{ inputModel } ->
                myCounter
                    { value = inputModel.value
                    , onIncrease = updateState updateSharedModel
                    }
        )
```

The same can be done for the InputChapter. But note that it's `updateState` now receives one parameter.

```elm
module InputChapter exposing (Model, init, chapter)

import ElmBook exposing (updateState1)

type alias Model = { value : String }

type alias SharedModel
    = { x | inputModel : Model }

updateSharedModel : Int -> SharedModel -> SharedModel
updateSharedModel value x =
    { x | inputModel = { value = value } }

chapter : ElmBook.Chapter SharedModel
chapter =
    ElmBook.chapter "InputChapter"
        |> withStatefulElement (
            \\{ inputModel } ->
                myInput
                    { value = inputModel.value
                    , onInput = updateState1 updateSharedModel
                    }
        )
```

---

### Nested Elm Architecture Example

Let's change our `InputChapter` so it now have it's own elm architecture.

```elm
module InputChapter exposing (Model, init, chapter)

import ElmBook exposing (updateState1)


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


type alias SharedModel
    = { x | inputModel : Model }


updateSharedModel : Msg -> SharedModel -> SharedModel
updateSharedModel msg shared =
    { shared | inputModel = update msg shared.inputModel }


chapter : ElmBook.Chapter SharedModel
chapter =
    ElmBook.chapter "InputChapter"
        |> withStatefulElement (
            \\{ inputModel } ->
                view inputModel
                    |> Html.map (updateState1 updateSharedModel)
        )
```


"""
