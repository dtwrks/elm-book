module ElmBook.Actions exposing
    ( logAction, logActionWithString, logActionWithBool, logActionWithInt, logActionWithFloat, logActionWith
    , updateState, updateStateWith, updateStateWithCmd, updateStateWithCmdWith
    , mapUpdate, mapUpdateWithCmd
    )

{-| This module focuses on actions – a.k.a messages your book may send to its runtime. There are mainly two types of actions:

  - **log actions** will not deal with any state. They will just print out some message to the action logger. This is pretty useful to get things running quickly.
  - **update actions** are used to update your book's shared state. A bit trickier to use but you can do a lot more powerful things with it.
  - **update mappers** are helpers for when you're using module with their own elm architecture.


# Logging Actions

Take a look at the ["Logging Actions"](https://elm-book-in-elm-book.netlify.app/guides/logging-actions) guide for some examples.

**Tip** If you want to test anchor elements without actually changing the current url, just pass in an url like `/logAction/some-url`. Your book will intercept any url change starting with `/logAction` and will log the action intent.

@docs logAction, logActionWithString, logActionWithBool, logActionWithInt, logActionWithFloat, logActionWith


# Update Actions

**Tip:** I highly recommend you read the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/logging-actions) guide to learn more about update actions and stateful chapters.

@docs updateState, updateStateWith, updateStateWithCmd, updateStateWithCmdWith


# "The Elm Architecture" helpers

If you're working on a module with its own elm architecture, these might make things a little simpler. Everything here _could_ be done with `updateState` but why not make things easier for ourselves?

    -- Your UI module stuff

    type alias Model = ...
    type Msg = ...

    update : Msg -> Model -> Model
    view : Model -> Html msg

    -- The elm-book stuff

    type alias ElmBookModel a =
        { a | inputModel : Model }

    chapter : Chapter (ElmBookModel a)
    chapter "Chapter with elm architecture"
        |> renderStatefulComponent (\{ inputModel } ->
            view inputModel
                |> Html.map (
                    mapUpdate
                        { toState = \state model -> { state | inputModel = model }
                        , fromState = \state -> state.inputModel
                        , update = update
                        }
                    )
        )

@docs mapUpdate, mapUpdateWithCmd

-}

import ElmBook.Internal.Msg exposing (..)


{-| Logs an action that takes no inputs.

    -- Will log "Clicked!" after pressing the button
    button [ onClick <| logAction "Clicked!" ] []

-}
logAction : String -> Msg state
logAction action =
    LogAction "" action


{-| Logs an action that takes one `String` input.

    -- Will log "Input: x" after pressing the "x" key
    input [ onInput <| logActionWithString "Input" ] []

-}
logActionWithString : String -> String -> Msg state
logActionWithString =
    logActionWith identity


{-| Logs an action that takes one `Int` input.

**WARNING**:

Folks, this is function is currently broken, my bad. It will be fixed in the next major release (which won't take long).
Until then please use the following replacement:

    logActionWith String.fromInt

-}
logActionWithInt : String -> String -> Msg state
logActionWithInt =
    logActionWith identity


{-| Logs an action that takes one `Float` input.

**WARNING**:

Folks, this is function is currently broken, my bad. It will be fixed in the next major release (which won't take long).
Until then please use the following replacement:

    logActionWith String.fromFloat

-}
logActionWithFloat : String -> String -> Msg state
logActionWithFloat =
    logActionWith identity


{-| Logs an action that takes one `Bool` input.
-}
logActionWithBool : String -> Bool -> Msg state
logActionWithBool =
    logActionWith stringFromBool


stringFromBool : Bool -> String
stringFromBool value =
    if value then
        "True"

    else
        "False"


{-| Logs an action that takes one generic input that can be transformed into a String.

    eventToString : Event -> String
    eventToString event =
        case event of
            Start ->
                "Start"

            Finish ->
                "Finish"

    myCustomComponent {
        onEvent =
            logActionWith
                eventToString
                "Received event"
    }

-}
logActionWith : (value -> String) -> String -> value -> Msg state
logActionWith toString action value =
    LogAction "" (action ++ ": " ++ toString value)



-- Updating State


{-| Updates the state of your stateful book.

    counterChapter : Chapter { x | counter : Int }
    counterChapter =
        let
            update state =
                { state | counter = state.counter + 1 }
        in
        chapter "Counter"
            |> withStatefulComponent
                (\state ->
                    button
                        [ onClick (updateState update) ]
                        [ text <| String.fromInt state.counter ]
                )

-}
updateState : (state -> state) -> Msg state
updateState fn =
    UpdateState (\state -> ( fn state, Cmd.none ))


{-| Used when updating the state based on an argument.

    inputChapter : Chapter { x | input : String }
    inputChapter =
        let
            updateInput value state =
                { state | input = value }
        in
        chapter "Input"
            |> withStatefulComponent
                (\state ->
                    input
                        [ value state.input
                        , onInput (updateStateWith updateInput)
                        ]
                        []
                )

-}
updateStateWith : (a -> state -> state) -> a -> Msg state
updateStateWith fn a =
    UpdateState (\state -> ( fn a state, Cmd.none ))


{-| Updates the state of your stateful book and possibly sends out a command. HTTP requests inside your book? Oh yeah! Get ready to go full over-engineering master.

    counterChapter : Chapter { x | counter : Int }
    counterChapter =
        let
            fetchCurrentCounter state =
                ( state
                , fetchCounterFromServer <|
                    updateState updateCounter
                )

            updateCounter newCounter state =
                { state | counter = newCounter }
        in
        chapter "Counter"
            |> withStatefulComponent
                (\state ->
                    button
                        [ onClick (updateStateWithCmd fetchCurrentCounter) ]
                        [ text <| String.fromInt state.counter ]
                )

-}
updateStateWithCmd : (state -> ( state, Cmd (Msg state) )) -> Msg state
updateStateWithCmd =
    UpdateState


{-| Same as `updateStateWith` but should return a `( state, Cmd msg )` tuple.
-}
updateStateWithCmdWith : (a -> state -> ( state, Cmd (Msg state) )) -> a -> Msg state
updateStateWithCmdWith fn =
    UpdateState << fn


{-| Maps a custom msg to an elm-book msg.
-}
mapUpdate :
    { fromState : state -> model
    , toState : state -> model -> state
    , update : msg -> model -> model
    }
    -> msg
    -> Msg state
mapUpdate config msg =
    let
        update_ msg_ state =
            config.update msg_ (config.fromState state)
                |> (\model -> ( config.toState state model, Cmd.none ))
    in
    updateStateWithCmdWith update_ msg


{-| Same as `mapUpdate` but used when your `update` returns a `( model, Cmd msg )` tuple.
-}
mapUpdateWithCmd :
    { fromState : state -> model
    , toState : state -> model -> state
    , update : msg -> model -> ( model, Cmd msg )
    }
    -> msg
    -> Msg state
mapUpdateWithCmd config msg =
    let
        update_ msg_ state =
            config.update msg_ (config.fromState state)
                |> Tuple.mapFirst (config.toState state)
                |> Tuple.mapSecond
                    (Cmd.map (updateStateWithCmd << update_))
    in
    updateStateWithCmdWith update_ msg
