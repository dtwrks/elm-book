module UIBook.UI.Placeholder exposing
    ( placeholder
    , custom, withBackgroundColor, withForegroundColor, withHeight, withWidth, view
    )

{-| When developing UI libraries, it's often useful to create "placeholders". Elements that fill the void on a container widget. Well – this is exactly that! Take a look at how you would use the default one:

    import UIBook.UI.Placeholder exposing (placeholder)

    card : Html msg -> Html msg
    card child = ...

    chapter "Card"
        |> withSection
            ( card placeholder )

@docs placeholder

You can also customize several aspects of it by creating a custom placeholder.

    chapter "Placeholder"
        |> withSections
            [ ( "Custom"
              , Placeholder.custom
                    |> Placeholder.withWidth 400.0
                    |> Placeholder.withForegroundColor "#FFFFFF"
                    |> Placeholder.view
              )
            ]

@docs custom, withBackgroundColor, withForegroundColor, withHeight, withWidth, view

-}

import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.UI.Header exposing (view)
import UIBook.UI.Helpers exposing (themeAccent, themeBackground)


type Props
    = Props { width : Maybe Float, height : Float, backgroundColor : String, foregroundColor : String }


{-| A placeholder can substitute any content in a chapter section
-}
placeholder : Html.Html msg
placeholder =
    view custom


{-| Builds a placeholder view with or without customized aspects
-}
view : Props -> Html.Html msg
view (Props props) =
    let
        width_ =
            case props.width of
                Just width__ ->
                    Css.width (px width__)

                Nothing ->
                    Css.width (pct 100)
    in
    div
        [ css
            [ opacity (Css.num 0.3)
            , Css.height (px props.height)
            , Css.maxHeight (pct 100)
            , width_
            , backgroundSize2 (px 10) (px 10)
            , Css.property "background-color" props.foregroundColor
            , Css.property "background-image" <|
                "repeating-linear-gradient(45deg, "
                    ++ props.foregroundColor
                    ++ " 0, "
                    ++ props.foregroundColor
                    ++ " 2px,"
                    ++ props.backgroundColor
                    ++ " 0,"
                    ++ props.backgroundColor
                    ++ " 50%)"
            ]
        ]
        []
        |> toUnstyled


{-| Contains all the customs properties of the placeholder
-}
custom : Props
custom =
    Props { width = Nothing, height = 40, backgroundColor = "#ffffff", foregroundColor = themeBackground }


{-| Sets a custom height for the placeholder
-}
withHeight : Float -> Props -> Props
withHeight height (Props props) =
    Props { props | height = height }


{-| Sets a custom width for the placeholder
-}
withWidth : Float -> Props -> Props
withWidth width (Props props) =
    Props { props | width = Just width }


{-| Sets a custom background color for the placeholder
-}
withBackgroundColor : String -> Props -> Props
withBackgroundColor color (Props props) =
    Props { props | backgroundColor = color }


{-| Sets a custom foreground color for the placeholder
-}
withForegroundColor : String -> Props -> Props
withForegroundColor color (Props props) =
    Props { props | foregroundColor = color }
