module ElmBook.Internal.Theme exposing
    ( Attribute
    , Theme
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


type alias Theme =
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
header theme =
    theme.header


logo : Theme -> Maybe (Html Never)
logo theme =
    theme.logo


subtitle : Theme -> Maybe String
subtitle theme =
    theme.subtitle


background : Theme -> String
background theme =
    theme.background


accent : Theme -> String
accent theme =
    theme.accent


fontSans : Theme -> String
fontSans theme =
    theme.fontSans


fontSerif : Theme -> String
fontSerif theme =
    theme.fontSerif


fontMonospace : Theme -> String
fontMonospace theme =
    theme.fontMonospace
