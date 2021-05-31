module UIBook.UI.Helpers exposing
    ( chapterSectionBackground
    , desktop
    , fontDefault
    , fontLabel
    , fontMonospace
    , fontSans
    , fontSerif
    , insetZero
    , mobile
    , scrollContent
    , scrollParent
    , setTheme
    , shadows
    , shadowsDark
    , shadowsInset
    , shadowsLight
    , themeAccent
    , themeAccentAlt
    , themeBackground
    , themeBackgroundAlt
    , wrapperMainBackground
    )

import Css exposing (..)
import Css.Media exposing (only, screen, withMedia)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)



-- Theme Color


themeBackgroundVar : String
themeBackgroundVar =
    "--ui-book-background"


themeBackgroundAltVar : String
themeBackgroundAltVar =
    "--ui-book-background-alt"


themeAccentVar : String
themeAccentVar =
    "--ui-book-accent"


themeAccentAltVar : String
themeAccentAltVar =
    "--ui-book-accent-alt"


setTheme : String -> String -> String -> String -> Attribute msg
setTheme background backgroundAlt_ accentColor_ accentAuxColor_ =
    attribute "style"
        ([ ( themeBackgroundVar, background )
         , ( themeBackgroundAltVar, backgroundAlt_ )
         , ( themeAccentVar, accentColor_ )
         , ( themeAccentAltVar, accentAuxColor_ )
         ]
            |> List.map (\( k, v ) -> k ++ ":" ++ v ++ ";")
            |> String.concat
        )


themeBackground : String
themeBackground =
    "var(" ++ themeBackgroundVar ++ ")"


themeBackgroundAlt : String
themeBackgroundAlt =
    "var(" ++ themeBackgroundAltVar ++ ")"


themeAccent : String
themeAccent =
    "var(" ++ themeAccentVar ++ ")"


themeAccentAlt : String
themeAccentAlt =
    "var(" ++ themeAccentAltVar ++ ")"


wrapperMainBackground : String
wrapperMainBackground =
    "#fbfbfd"


chapterSectionBackground : String
chapterSectionBackground =
    "#fff"



-- Media Queries


mobile : List Style -> Style
mobile =
    withMedia [ only screen [ Css.Media.maxWidth (px 768) ] ]


desktop : List Style -> Style
desktop =
    withMedia [ only screen [ Css.Media.minWidth (px 1200) ] ]



-- Typography


fontDefault : Style
fontDefault =
    Css.batch
        [ fontSans
        , color (hex "#292929")
        ]


fontLabel : Style
fontLabel =
    Css.batch
        [ fontDefault
        , fontSize (px 14)
        , letterSpacing (px 0.5)
        ]


fontSans : Style
fontSans =
    fontFamilies [ "IBM Plex Sans", "sans-serif" ]


fontSerif : Style
fontSerif =
    fontFamilies [ "IBM Plex Serif", "serif" ]


fontMonospace : Style
fontMonospace =
    fontFamilies [ "Fira Code", "monospace" ]



-- Shadows


shadows : Style
shadows =
    boxShadow4 (px 0) (px 0) (px 20) (rgba 0 0 0 0.05)


shadowsDark : Style
shadowsDark =
    boxShadow4 (px 0) (px 0) (px 20) (rgba 0 0 0 0.1)


shadowsLight : Style
shadowsLight =
    boxShadow4 (px 0) (px 1) (px 4) (rgba 0 0 0 0.15)


shadowsInset : Style
shadowsInset =
    boxShadow5 inset (px 0) (px 0) (px 20) (rgba 0 0 0 0.05)



-- Layout


insetZero : Style
insetZero =
    Css.batch
        [ position absolute
        , top zero
        , left zero
        , right zero
        , bottom zero
        ]


scrollParent : Style
scrollParent =
    Css.batch
        [ position relative
        , overflow Css.hidden
        ]


scrollContent : Style
scrollContent =
    Css.batch
        [ insetZero
        , overflow auto
        ]
