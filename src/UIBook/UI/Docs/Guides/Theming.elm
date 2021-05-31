module UIBook.UI.Docs.Guides.Theming exposing (..)

import Css exposing (..)
import ElmBook exposing (chapter, themeAccentAlt, themeBackground, withBackgroundColor, withDescription, withSection, withSections, withTwoColumns)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.ElmCSS exposing (UIChapter)
import UIBook.UI.Helpers exposing (fontDefault, insetZero, themeBackgroundAlt, wrapperMainBackground)


description : String
description =
    """
### Header Customizations

<example key="1" />

    main : UIBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []

### Colors Themes

    main : UIBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []

"""


docs : UIChapter x
docs =
    chapter "Theming"
        |> withTwoColumns
        |> withDescription description
        |> withBackgroundColor themeBackground
        |> withSections
            [ ( "1"
              , div
                    [ css
                        [ displayFlex
                        , alignItems stretch
                        , padding (px 16)
                        , fontDefault
                        ]
                    ]
                    [ div [ css [ Css.width (pct 60) ] ]
                        [ p
                            [ style "color" themeAccentAlt
                            , css [ padding2 zero (px 20) ]
                            ]
                            [ text "Theme Accent Alt"
                            , br [] []
                            , span [ css [ fontSize (px 12), opacity (num 0.8) ] ]
                                [ text "(Theme Background)"
                                ]
                            ]
                        , div
                            [ css [ position relative ] ]
                            [ div
                                [ css [ insetZero, opacity (num 0.2) ]
                                , style "background-color" themeBackgroundAlt
                                ]
                                []
                            , p
                                [ css
                                    [ padding4 (px 8) (px 48) (px 8) (px 20)
                                    , position relative
                                    , zIndex (int 1)
                                    ]
                                , style "color" themeAccentAlt
                                ]
                                [ text "Theme Accent"
                                , br [] []
                                , span [ css [ fontSize (px 12), opacity (num 0.8) ] ]
                                    [ text "(Theme Background Alt)"
                                    ]
                                ]
                            ]
                        ]
                    , div
                        [ css
                            [ Css.width (pct 40)
                            , borderRadius (px 4)
                            , backgroundColor (hex wrapperMainBackground)
                            ]
                        ]
                        []
                    ]
              )
            ]
