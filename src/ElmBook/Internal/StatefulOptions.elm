module ElmBook.Internal.StatefulOptions exposing
    ( StatefulOptions
    , defaultOptions
    )

import ElmBook.Internal.Msg exposing (Msg)


type alias StatefulOptions state subMsg =
    { initialState : Maybe state
    , onDarkModeChange : Bool -> state -> state
    , subscriptions : List (Sub (Msg state subMsg))
    }


defaultOptions : StatefulOptions state subMsg
defaultOptions =
    { initialState = Nothing
    , onDarkModeChange = \_ -> identity
    , subscriptions = []
    }
