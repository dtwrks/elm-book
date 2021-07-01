module ElmBook.Theme exposing
    ( subtitle, logo, header
    , background, backgroundGradient, accent
    )

{-| Use the attributes provided by this module to customize your book through `ElmBook.withThemeOptions`.

Take a look at the ["Theming"](https://elm-book-in-elm-book.netlify.app/guides/theming) guide for some examples.


# Header

@docs subtitle, logo, header


# Color palette

@docs background, backgroundGradient, accent

-}

import ElmBook.Internal.Theme
import Html exposing (Html)


type alias Attribute =
    ElmBook.Internal.Theme.Attribute


{-| Provide a custom logo for your book.
-}
logo : Html Never -> Attribute
logo logo_ theme =
    { theme | logo = Just logo_ }


{-| Define a custom subtitle for your book. This will appear below the title.
-}
subtitle : String -> Attribute
subtitle subtitle_ theme =
    { theme | subtitle = Just subtitle_ }


{-| Provide a completely custom header to your book. This will replace the whole area where usually the logo, title and subtitle appears.
-}
header : Html Never -> Attribute
header header_ theme =
    { theme | header = Just header_ }


{-| Customize the background color of your book. Any valid value for the `background` CSS property will work.
-}
background : String -> Attribute
background background_ theme =
    { theme | background = background_ }


{-| Customize the background of your book using a gradient by providing the start and end color. This is just a helper since the same thing can be achieved by using the `background` attribute.
-}
backgroundGradient : String -> String -> Attribute
backgroundGradient startColor endColor theme =
    { theme
        | background =
            "linear-gradient(150deg, "
                ++ startColor
                ++ " 0%, "
                ++ endColor
                ++ " 100%)"
    }


{-| Customize the accent color of your book. This will change the color for all elements that sit on top of your background.
-}
accent : String -> Attribute
accent background_ theme =
    { theme | accent = background_ }
