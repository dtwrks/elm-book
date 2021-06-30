module ElmBook.Internal.ApplicationOptions exposing
    ( ApplicationOptions
    , Attribute
    , defaultOptions
    )

import ElmBook.Internal.Msg exposing (Msg)


type alias Attribute state html =
    ApplicationOptions state html -> ApplicationOptions state html


type alias ApplicationOptions state html =
    { globals : Maybe (List html)
    , state : Maybe state
    , subscriptions : List (Sub (Msg state))
    }


defaultOptions : ApplicationOptions state html
defaultOptions =
    { globals = Nothing
    , state = Nothing
    , subscriptions = []
    }
