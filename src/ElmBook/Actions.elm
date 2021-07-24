module ElmBook.Actions exposing
    ( logAction, logActionWithString, logActionWithBool, logActionWithInt, logActionWithFloat, logActionWith
    , updateState, updateStateWith, updateStateWithCmd, updateStateWithCmdWith
    )

{-| This module focuses on actions – a.k.a messages your book may send to its runtime. There are mainly two types of actions:

  - **log actions** will not deal with any state. They will just print out some message to the action logger. This is pretty useful to get things running quickly.
  - **update actions** are used to update your book's shared state. A bit trickier to use but you can do a lot more powerful things with it.


# Logging Actions

Take a look at the ["Logging Actions"](https://elm-book-in-elm-book.netlify.app/guides/logging-actions) guide for some examples.

**Tip** If you want to test anchor elements without actually changing the current url, just pass in an url like `/logAction/some-url`. Your book will intercept any url change starting with `/logAction` and will log the action intent.

@docs logAction, logActionWithString, logActionWithBool, logActionWithInt, logActionWithFloat, logActionWith


# Updating Actions

**Tip:** I highly recommend you read the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/logging-actions) guide to learn more about update actions and stateful chapters.

@docs updateState, updateStateWith, updateStateWithCmd, updateStateWithCmdWith

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
    case value of
        True ->
            "True"

        False ->
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
updateState =
    UpdateState


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
updateStateWith fn =
    UpdateState << fn


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
    UpdateStateWithCmd


{-| Same as `updateStateWith` but should return a `( state, Cmd msg )` tuple.
-}
updateStateWithCmdWith : (a -> state -> ( state, Cmd (Msg state) )) -> a -> Msg state
updateStateWithCmdWith fn =
    UpdateStateWithCmd << fn
