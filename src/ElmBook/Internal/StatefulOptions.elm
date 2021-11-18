module ElmBook.Internal.StatefulOptions exposing
    ( StatefulOptions
    , defaultOptions
    )

import ElmBook.Internal.Msg exposing (Msg)


type alias StatefulOptions state subMsg =
    { initialState : Maybe state
    , update : subMsg -> state -> ( state, Cmd subMsg )
    , onDarkModeChange : Bool -> state -> state
    , subscriptions : List (Sub (Msg state subMsg))
    }


defaultOptions : StatefulOptions state subMsg
defaultOptions =
    { initialState = Nothing
    , update = \_ state -> ( state, Cmd.none )
    , onDarkModeChange = \_ -> identity
    , subscriptions = []
    }
