module ElmBook.Actions exposing
    ( logAction
    , logActionMap
    , logActionWithFloat
    , logActionWithInt
    , logActionWithString
    , updateState
    , updateState1
    )

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
    input [ onInput <| logActionWithString "Input: " ] []

-}
logActionWithString : String -> String -> Msg state
logActionWithString action value =
    LogAction "" (action ++ ": " ++ value)


{-| Logs an action that takes one `Int` input.
-}
logActionWithInt : String -> String -> Msg state
logActionWithInt action value =
    LogAction "" (action ++ ": " ++ value)


{-| Logs an action that takes one `Float` input.
-}
logActionWithFloat : String -> String -> Msg state
logActionWithFloat action value =
    LogAction "" (action ++ ": " ++ value)


{-| Logs an action that takes one generic input that can be transformed into a String.

    eventToString : Event -> String
    eventToString event =
        case event of
            Start ->
                "Start"

            Finish ->
                "Finish"

    myCustomElement {
        onEvent =
            logActionMap "My Custom Element: " eventToString
    }

-}
logActionMap : String -> (value -> String) -> value -> Msg state
logActionMap action toString value =
    LogAction "" (action ++ ": " ++ toString value)



-- Updating State


{-| Updates the state of your stateful book.

    counterChapter : UIChapter { x | counter : Int }
    counterChapter =
        let
            update state =
                { state | counter = state.counter + 1 }
        in
        chapter "Counter"
            |> withStatefulElement
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

    inputChapter : UIChapter { x | input : String }
    inputChapter =
        let
            updateInput value state =
                { state | input = value }
        in
        chapter "Input"
            |> withStatefulElement
                (\state ->
                    input
                        [ value state.input
                        , onInput (updateState1 updateInput)
                        ]
                        []
                )

-}
updateState1 : (a -> state -> state) -> a -> Msg state
updateState1 fn =
    UpdateState << fn
