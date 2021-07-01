module ElmBook.Theme exposing
    ( Theme
    , accent
    , background
    , backgroundGradient
    , header
    , logo
    , subtitle
    )

import ElmBook.Internal.Theme
import Html exposing (Html)


type alias Theme =
    ElmBook.Internal.Theme.Theme


type alias Attribute =
    ElmBook.Internal.Theme.Attribute


header : Html Never -> Attribute
header header_ theme =
    { theme | header = Just header_ }


logo : Html Never -> Attribute
logo logo_ theme =
    { theme | logo = Just logo_ }


subtitle : String -> Attribute
subtitle subtitle_ theme =
    { theme | subtitle = Just subtitle_ }


background : String -> Attribute
background background_ theme =
    { theme | background = background_ }


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


accent : String -> Attribute
accent background_ theme =
    { theme | accent = background_ }
