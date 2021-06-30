module ElmBook.Internal.ApplicationOptions exposing (..)

import ElmBook.Internal.Msg exposing (Msg)


type alias ApplicationOptions state html =
    { globals : Maybe (List html)
    , state : Maybe state
    , subscriptions : Maybe (Sub (Msg state))
    }


defaultOptions : ApplicationOptions state html
defaultOptions =
    { globals = Nothing
    , state = Nothing
    , subscriptions = Nothing
    }
