module ElmBook.Internal.StatefulOptions exposing
    ( StatefulOptions
    , defaultOptions
    )

import ElmBook.Internal.Msg exposing (Msg)


type alias StatefulOptions state =
    { initialState : Maybe state
    , onDarkModeChange : Bool -> state -> state
    , subscriptions : List (Sub (Msg state))
    }


defaultOptions : StatefulOptions state
defaultOptions =
    { initialState = Nothing
    , onDarkModeChange = \_ -> identity
    , subscriptions = []
    }
