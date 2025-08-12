module ElmBook.StatefulOptions exposing
    ( initialState, subscriptions, onDarkModeChange
    , Attribute, initialStateExtra, subscriptionsExtra
    )

{-| Attributes used by `ElmBook.withStatefulOptions`.

The attributes below are mostly used for Stateful Books. Take a look at the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide for more details.

@docs initialState, initialStateExtra, subscriptions, subscriptionsExtra, onDarkModeChange


# Types

@docs Attribute

-}

import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.StatefulOptions exposing (StatefulOptions)
import Json.Encode
import Browser.Navigation


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
    { options | initialState = Just (\_ _ -> state) }


{-| Improved version of `initialState`.

Receives your application's flags as JSON encode value and the Browser.Navigation.Key as inputs to your custom state init function.

    type alias SharedState =
        { flags : Json.Encode.Value
        , navKey : Browser.Navigation.Key
        }


    book : Book SharedState
    book "MyApp"
        |> withStatefulOptions [
            initialStateExtra (\flags navKey ->
                { flags = flags
                , navKey = navKey
                }
            )
        ]

-}
initialStateExtra : (Json.Encode.Value -> Browser.Navigation.Key -> state) -> Attribute state
initialStateExtra fn options =
    { options | initialState = Just fn }


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
    { options | subscriptions = (\_ -> Sub.batch subscriptions_) }

{-| Improved version of `subscriptions`.

Receives your custom state as an input to your subscriptions.

-}
subscriptionsExtra : (state -> Sub (Msg state)) -> Attribute state
subscriptionsExtra fn options =
    { options | subscriptions = fn }

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
