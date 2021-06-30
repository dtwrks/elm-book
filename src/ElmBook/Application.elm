module ElmBook.Application exposing
    ( globals
    , initialState
    , subscriptions
    )

import ElmBook.Internal.ApplicationOptions exposing (ApplicationOptions)
import ElmBook.Internal.Msg exposing (Msg)


{-| Add global elements to your book. This can be helpful for things like CSS resets.

For instance, if you're using elm-tailwind-modules, this would be really helpful:

    import Css.Global exposing (global)
    import Tailwind.Utilities exposing (globalStyles)

    book "MyApp"
        |> withApplicationOptions [
            globals [ global globalStyles ]
        ]

-}
globals : List html -> ApplicationOptions state html -> ApplicationOptions state html
globals globals_ options =
    { options | globals = Just globals_ }


{-| Add an initial state to your stateful book.

    type alias SharedState =
        { value : String }


    book : Book SharedState
    book "MyApp"
        |> withApplicationOptions [
            initialState { value = "" }
        ]

-}
initialState : state -> ApplicationOptions state html -> ApplicationOptions state html
initialState state options =
    { options | state = Just state }


{-| Add subscriptions to your book. Mostly useful for stateful books.

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
        |> withApplicationOptions [
            subscriptions [
                Browser.Events.onAnimationFrame
                    (updateStateWith updateAnimationState)
            ]
        ]

-}
subscriptions : Sub (Msg state) -> ApplicationOptions state html -> ApplicationOptions state html
subscriptions subscriptions_ options =
    { options | subscriptions = Just subscriptions_ }
