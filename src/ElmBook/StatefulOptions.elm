module ElmBook.StatefulOptions exposing
    ( initialState, update, subscriptions, onDarkModeChange
    , Attribute
    )

{-| Attributes used by `ElmBook.withStatefulOptions`.

The attributes below are mostly used for Stateful Books. Take a look at the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide for more details.

@docs initialState, update, subscriptions, onDarkModeChange


# Types

@docs Attribute

-}

import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.StatefulOptions exposing (StatefulOptions)


{-| -}
type alias Attribute state subMsg =
    StatefulOptions state subMsg -> StatefulOptions state subMsg


{-| Add an initial state to your book.

    type alias SharedState =
        { value : String }


    book : Book SharedState y
    book "MyApp"
        |> withStatefulOptions [
            initialState { value = "" }
        ]

-}
initialState : state -> Attribute state subMsg
initialState state options =
    { options | initialState = Just state }


{-| Update the shared state with your own msg type.

    type alias SharedState =
        { childComponent : ChildComponent.Model }

    type Msg
        = GotChildComponentMsg ChildComponent.Msg

    updateSharedState : SharedState -> Msg -> ( SharedState, Cmd Msg )
    updateSharedState sharedState msg =
        case msg of
            UpdatedChildComponent subMsg ->
                let
                    ( childComponent, cmd ) =
                        ChildComponent.update subMsg sharedState.childComponent
                in
                ( { sharedState | childComponent = childComponent }
                , Cmd.map GotChildComponentMsg cmd
                )

    book : Book SharedState Msg
    book "MyApp"
        |> withStatefulOptions [
            update updateSharedState
        ]

-}
update : (subMsg -> state -> ( state, Cmd subMsg )) -> Attribute state subMsg
update updateFn options =
    { options | update = updateFn }


{-| Add subscriptions to your book.

    import ElmBook.Actions exposing (updateState)

    type alias SharedState =
        { value : String
        , timestamp : Posix
        }


    updateAnimationState : Posix -> SharedState -> SharedState
    updateAnimationState posix state =
        { state | timestamp = posix }


    book : Book SharedState y
    book "MyApp"
        |> withStatefulOptions [
            subscriptions [
                Browser.Events.onAnimationFrame
                    (updateStateWith updateAnimationState)
            ]
        ]

-}
subscriptions : List (Sub (Msg state subMsg)) -> Attribute state subMsg
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

    book : Book SharedState y
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
onDarkModeChange : (Bool -> state -> state) -> Attribute state subMsg
onDarkModeChange onDarkModeChange_ options =
    { options | onDarkModeChange = onDarkModeChange_ }
