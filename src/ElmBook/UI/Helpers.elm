module ElmBook.UI.Helpers exposing
    ( baseStyles
    , chapterSectionBackground
    , css_
    , mediaLargeScreen
    , mediaMobile
    , setTheme
    , themeAccent
    , themeBackground
    , wrapperMainBackground
    )

import Html exposing (..)
import Html.Attributes exposing (..)



-- Theme Color


themeBackgroundVar : String
themeBackgroundVar =
    "--elm-book-background"


themeAccentVar : String
themeAccentVar =
    "--elm-book-accent"


setTheme : String -> String -> Attribute msg
setTheme background accentColor_ =
    attribute "style"
        ([ ( themeBackgroundVar, background )
         , ( themeAccentVar, accentColor_ )
         ]
            |> List.map (\( k, v ) -> k ++ ":" ++ v ++ ";")
            |> String.concat
        )


themeBackground : String
themeBackground =
    "var(" ++ themeBackgroundVar ++ ")"


themeAccent : String
themeAccent =
    "var(" ++ themeAccentVar ++ ")"


wrapperMainBackground : String
wrapperMainBackground =
    "#fbfbfd"


chapterSectionBackground : String
chapterSectionBackground =
    "#fff"



-- Media Queries


mediaMobile : String
mediaMobile =
    "@media screen and (max-width: 768px)"


mediaLargeScreen : String
mediaLargeScreen =
    "@media screen and (min-width: 1720px)"



-- Styles


css_ : String -> Html.Html msg
css_ x =
    Html.node "style" [] [ Html.text x ]


baseStyles : Html msg
baseStyles =
    css_ """
@import url('https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;600&family=IBM+Plex+Sans:wght@300;400;600&family=IBM+Plex+Serif:ital,wght@0,400;0,600;1,400;1,600&display=swap');

@keyframes fade-in {
  from { opacity: 0; }
  to   { opacity: 1; }
}

.elm-book-fade-in {
    animation: 0.3s linear fade-in;
}

.elm-book-wrapper * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

.elm-book-wrapper,
.elm-book {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

.elm-book-sans {
    font-family: "IBM Plex Sans", "sans-serif";
}

.elm-book-serif {
    font-family: "IBM Plex Serif", "serif";
}

.elm-book-monospace {
    font-family: "Fira Code", "monospace";
}

.elm-book-inset {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
}

.elm-book-shadows {
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
}

.elm-book-shadows-light {
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15);
}
"""
