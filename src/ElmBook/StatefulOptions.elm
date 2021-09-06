module ElmBook.StatefulOptions exposing
    ( initialState, subscriptions, onDarkModeChange
    , Attribute
    )

{-| Attributes used by `ElmBook.withStatefulOptions`.

The attributes below are mostly used for Stateful Books. Take a look at the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide for more details.

@docs initialState, subscriptions, onDarkModeChange


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
    { options | initialState = Just state }


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


{-| Change your book's state based on the themes current mode.

This can be useful for showcasing your own dark themed components when using elm-book's dark mode.

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
                (\darkMode state ->
                    { state | darkMode = darkMode }
                )
            ]

-}
onDarkModeChange : (Bool -> state -> state) -> Attribute state
onDarkModeChange onDarkModeChange_ options =
    { options | onDarkModeChange = onDarkModeChange_ }
