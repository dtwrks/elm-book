module ElmBook.Internal.Theme exposing
    ( Attribute
    , Theme(..)
    , accent
    , background
    , defaultTheme
    , fontMonospace
    , fontSans
    , fontSerif
    , header
    , logo
    , subtitle
    )

import Html exposing (Html)


type Theme
    = Theme
        { header : Maybe (Html Never)
        , logo : Maybe (Html Never)
        , subtitle : Maybe String
        , background : String
        , accent : String
        , fontSans : String
        , fontSerif : String
        , fontMonospace : String
        }


type alias Attribute =
    Theme -> Theme


defaultTheme : Theme
defaultTheme =
    Theme
        { header = Nothing
        , logo = Nothing
        , subtitle = Nothing
        , background =
            "linear-gradient(150deg, rgba(0,135,207,1) 0%, rgba(86,207,255,1) 100%)"
        , accent = "#fff"
        , fontSans = "IBM Plex Sans"
        , fontSerif = "IBM Plex Serif"
        , fontMonospace = "Fira Code"
        }


header : Theme -> Maybe (Html Never)
header (Theme theme) =
    theme.header


logo : Theme -> Maybe (Html Never)
logo (Theme theme) =
    theme.logo


subtitle : Theme -> Maybe String
subtitle (Theme theme) =
    theme.subtitle


background : Theme -> String
background (Theme theme) =
    theme.background


accent : Theme -> String
accent (Theme theme) =
    theme.accent


fontSans : Theme -> String
fontSans (Theme theme) =
    theme.fontSans


fontSerif : Theme -> String
fontSerif (Theme theme) =
    theme.fontSerif


fontMonospace : Theme -> String
fontMonospace (Theme theme) =
    theme.fontMonospace
