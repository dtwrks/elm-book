module ElmBook.Internal.ComponentOptions exposing (..)


type alias ValidComponentOptions =
    { hiddenLabel : Bool
    , background : String
    , display : Layout
    , fullWidth : Bool
    }


type Layout
    = Block
    | Inline
    | Card


type ComponentOptions
    = ComponentOptions
        { hiddenLabel : Maybe Bool
        , background : Maybe String
        , display : Maybe Layout
        , fullWidth : Maybe Bool
        }


type alias Attribute =
    ComponentOptions -> ComponentOptions


defaultOptions : ValidComponentOptions
defaultOptions =
    { hiddenLabel = False
    , background = ""
    , display = Card
    , fullWidth = False
    }


defaultOverrides : ComponentOptions
defaultOverrides =
    ComponentOptions
        { hiddenLabel = Nothing
        , background = Nothing
        , display = Nothing
        , fullWidth = Nothing
        }


markdownOptions :
    ValidComponentOptions
    ->
        { hiddenLabel : Maybe String
        , background : Maybe String
        , display : Maybe String
        , fullWidth : Maybe String
        }
    -> ValidComponentOptions
markdownOptions validOptions options =
    toValidOptions validOptions
        (ComponentOptions
            { hiddenLabel = parseBool options.hiddenLabel
            , background = options.background
            , display = parseDisplay options.display
            , fullWidth = parseBool options.fullWidth
            }
        )


toValidOptions : ValidComponentOptions -> ComponentOptions -> ValidComponentOptions
toValidOptions validSettings (ComponentOptions settings) =
    { hiddenLabel =
        settings.hiddenLabel
            |> Maybe.withDefault validSettings.hiddenLabel
    , background =
        settings.background
            |> Maybe.withDefault validSettings.background
    , display =
        settings.display
            |> Maybe.withDefault validSettings.display
    , fullWidth =
        settings.fullWidth
            |> Maybe.withDefault validSettings.fullWidth
    }


parseBool : Maybe String -> Maybe Bool
parseBool v =
    case v of
        Just "true" ->
            Just True

        _ ->
            Nothing


parseDisplay : Maybe String -> Maybe Layout
parseDisplay displayString =
    case displayString of
        Just "block" ->
            Just Block

        Just "inline" ->
            Just Inline

        Just "card" ->
            Just Card

        _ ->
            Nothing
