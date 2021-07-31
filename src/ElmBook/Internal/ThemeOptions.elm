module ElmBook.Internal.ThemeOptions exposing
    ( ThemeOptions
    , accent
    , background
    , defaultAccent
    , defaultBackgroundEnd
    , defaultBackgroundStart
    , defaultNavAccent
    , defaultNavAccentHighlight
    , defaultNavBackground
    , defaultTheme
    , fontMonospace
    , fontSans
    , fontSerif
    , header
    , logo
    , navAccent
    , navAccentHighlight
    , navBackground
    , subtitle
    , useHashBasedNavigation
    )


type alias ThemeOptions html =
    { globals : Maybe (List html)
    , preferDarkMode : Bool
    , header : Maybe html
    , logo : Maybe html
    , subtitle : Maybe String
    , background : String
    , accent : String
    , navBackground : String
    , navAccent : String
    , navAccentHighlight : String
    , fontSans : String
    , fontSerif : String
    , fontMonospace : String
    , useHashBasedNavigation : Bool
    }


defaultBackgroundStart : String
defaultBackgroundStart =
    "#0087cf"


defaultBackgroundEnd : String
defaultBackgroundEnd =
    "#56cfff"


defaultNavBackground : String
defaultNavBackground =
    "#ffffff"


defaultAccent : String
defaultAccent =
    "#ffffff"


defaultNavAccent : String
defaultNavAccent =
    "#bdecff"


defaultNavAccentHighlight : String
defaultNavAccentHighlight =
    "#ffffff"


defaultTheme : ThemeOptions html
defaultTheme =
    { globals = Nothing
    , preferDarkMode = False
    , header = Nothing
    , logo = Nothing
    , subtitle = Nothing
    , background =
        "linear-gradient(150deg, " ++ defaultBackgroundStart ++ " 0%, " ++ defaultBackgroundEnd ++ " 100%)"
    , accent = defaultAccent
    , navBackground = defaultNavBackground
    , navAccent = defaultNavAccent
    , navAccentHighlight = defaultNavAccentHighlight
    , fontSans = "IBM Plex Sans"
    , fontSerif = "IBM Plex Serif"
    , fontMonospace = "Fira Code"
    , useHashBasedNavigation = False
    }


header : ThemeOptions html -> Maybe html
header theme =
    theme.header


logo : ThemeOptions html -> Maybe html
logo theme =
    theme.logo


subtitle : ThemeOptions html -> Maybe String
subtitle theme =
    theme.subtitle


background : ThemeOptions html -> String
background theme =
    theme.background


accent : ThemeOptions html -> String
accent theme =
    theme.accent


navBackground : ThemeOptions html -> String
navBackground theme =
    theme.navBackground


navAccent : ThemeOptions html -> String
navAccent theme =
    theme.navAccent


navAccentHighlight : ThemeOptions html -> String
navAccentHighlight theme =
    theme.navAccentHighlight


fontSans : ThemeOptions html -> String
fontSans theme =
    theme.fontSans


fontSerif : ThemeOptions html -> String
fontSerif theme =
    theme.fontSerif


fontMonospace : ThemeOptions html -> String
fontMonospace theme =
    theme.fontMonospace


useHashBasedNavigation : ThemeOptions html -> Bool
useHashBasedNavigation =
    .useHashBasedNavigation
