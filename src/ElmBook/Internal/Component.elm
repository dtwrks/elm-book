module ElmBook.Internal.Component exposing (..)


type alias ValidComponentOptions =
    { hiddenLabel : Bool
    , background : String
    , layout : Layout
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
        , layout : Maybe Layout
        , fullWidth : Maybe Bool
        }


type alias Attribute =
    ComponentOptions -> ComponentOptions


defaultOptions : ValidComponentOptions
defaultOptions =
    { hiddenLabel = False
    , background = "#fff"
    , layout = Card
    , fullWidth = False
    }


defaultOverrides : ComponentOptions
defaultOverrides =
    ComponentOptions
        { hiddenLabel = Nothing
        , background = Nothing
        , layout = Nothing
        , fullWidth = Nothing
        }


markdownOptions :
    ValidComponentOptions
    ->
        { hiddenLabel : Maybe String
        , background : Maybe String
        , layout : Maybe String
        , fullWidth : Maybe String
        }
    -> ValidComponentOptions
markdownOptions validOptions options =
    toValidOptions validOptions
        (ComponentOptions
            { hiddenLabel = parseBool options.hiddenLabel
            , background = options.background
            , layout = parseLayout options.layout
            , fullWidth = parseBool options.fullWidth
            }
        )


applyAttributes : List (ComponentOptions -> ComponentOptions) -> ComponentOptions -> ComponentOptions
applyAttributes fns settings =
    List.foldl (\fn acc -> fn acc) settings fns


toValidOptions : ValidComponentOptions -> ComponentOptions -> ValidComponentOptions
toValidOptions validSettings (ComponentOptions settings) =
    { hiddenLabel =
        settings.hiddenLabel
            |> Maybe.withDefault validSettings.hiddenLabel
    , background =
        settings.background
            |> Maybe.withDefault validSettings.background
    , layout =
        settings.layout
            |> Maybe.withDefault validSettings.layout
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


parseLayout : Maybe String -> Maybe Layout
parseLayout layoutString =
    case layoutString of
        Just "block" ->
            Just Block

        Just "inline" ->
            Just Inline

        Just "card" ->
            Just Card

        _ ->
            Nothing
