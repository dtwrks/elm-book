module ElmBook.Internal.StatefulOptions exposing
    ( StatefulOptions
    , defaultOptions
    )

import ElmBook.Internal.Msg exposing (Msg)
import Json.Encode
import Browser.Navigation


type alias StatefulOptions state =
    { initialState : Maybe (Json.Encode.Value -> Browser.Navigation.Key -> state)
    , onDarkModeChange : Bool -> state -> state
    , subscriptions : state -> Sub (Msg state)
    }


defaultOptions : StatefulOptions state
defaultOptions =
    { initialState = Nothing
    , onDarkModeChange = \_ -> identity
    , subscriptions = \_ -> Sub.none
    }
