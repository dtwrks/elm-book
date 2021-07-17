module ElmBook.StatefulOptions exposing
    ( initialState, subscriptions
    , Attribute
    )

{-| Attributes used by `ElmBook.withStatefulOptions`.

The attributes below are mostly used for Stateful Books. Take a look at the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide for more details.

@docs initialState, subscriptions


# Types

@docs Attribute

-}

import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.StatefulOptions exposing (StatefulOptions)


{-| -}
type alias Attribute state =
    StatefulOptions state -> StatefulOptions state


{-| Add an initial state to your book.

    type alias SharedState =
        { value : String }


    book : Book SharedState
    book "MyApp"
        |> withStatefulOptions [
            initialState { value = "" }
        ]

-}
initialState : state -> Attribute state
initialState state options =
    { options | state = Just state }


{-| Add subscriptions to your book.

    import ElmBook.Actions exposing (updateState)

    type alias SharedState =
        { value : String
        , timestamp : Posix
        }


    updateAnimationState : Posix -> SharedState -> SharedState
    updateAnimationState posix state =
        { state | timestamp = posix }


    book : Book SharedState
    book "MyApp"
        |> withStatefulOptions [
            subscriptions [
                Browser.Events.onAnimationFrame
                    (updateStateWith updateAnimationState)
            ]
        ]

-}
subscriptions : List (Sub (Msg state)) -> Attribute state
subscriptions subscriptions_ options =
    { options | subscriptions = subscriptions_ }
