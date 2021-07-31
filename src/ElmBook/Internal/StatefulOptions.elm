module ElmBook.Internal.StatefulOptions exposing
    ( StatefulOptions
    , defaultOptions
    )

import ElmBook.Internal.Msg exposing (Msg)


type alias StatefulOptions state =
    { state : Maybe state
    , onDarkModeChange : Bool -> state -> state
    , subscriptions : List (Sub (Msg state))
    }


defaultOptions : StatefulOptions state
defaultOptions =
    { state = Nothing
    , onDarkModeChange = \_ -> identity
    , subscriptions = []
    }
