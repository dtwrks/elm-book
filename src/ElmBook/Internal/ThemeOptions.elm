module ElmBook.Internal.ThemeOptions exposing
    ( ThemeOptionOverrides
    , ThemeOptions
    , accent
    , applyOverrides
    , background
    , defaultAccent
    , defaultBackgroundEnd
    , defaultBackgroundStart
    , defaultNavAccent
    , defaultNavAccentHighlight
    , defaultNavBackground
    , defaultOverrides
    , defaultTheme
    , fontMonospace
    , fontSans
    , fontSerif
    , hashBasedNavigation
    , header
    , logo
    , navAccent
    , navAccentHighlight
    , navBackground
    , subtitle
    )


type alias ThemeOptions html =
    { globals : Maybe (List html)
    , routePrefix : String
    , hashBasedNavigation : Bool
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
    }


type alias ThemeOptionOverrides =
    { background : Maybe String
    , accent : Maybe String
    , navBackground : Maybe String
    , navAccent : Maybe String
    , navAccentHighlight : Maybe String
    }


defaultOverrides : ThemeOptionOverrides
defaultOverrides =
    { background = Nothing
    , accent = Nothing
    , navBackground = Nothing
    , navAccent = Nothing
    , navAccentHighlight = Nothing
    }


applyOverrides : ThemeOptions html -> ThemeOptionOverrides -> ThemeOptions html
applyOverrides theme overrides =
    { theme
        | background = Maybe.withDefault theme.background overrides.background
        , accent = Maybe.withDefault theme.accent overrides.accent
        , navBackground = Maybe.withDefault theme.navBackground overrides.navBackground
        , navAccent = Maybe.withDefault theme.navAccent overrides.navAccent
        , navAccentHighlight = Maybe.withDefault theme.navAccentHighlight overrides.navAccentHighlight
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
    , routePrefix = ""
    , hashBasedNavigation = False
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


routePrefix : ThemeOptions html -> Bool
routePrefix =
    .hashBasedNavigation


hashBasedNavigation : ThemeOptions html -> Bool
hashBasedNavigation =
    .hashBasedNavigation
