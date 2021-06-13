module ElmBook.UI.Docs.Guides.Theming exposing (..)

import ElmBook exposing (UIChapter, chapter, render, themeBackground, withBackgroundColor, withElement, withTwoColumns)
import ElmBook.UI.Helpers exposing (css_)
import Html exposing (..)
import Html.Attributes exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book-docs__theming__theme {
    displauy: flex;
    align-items: stretch;
    padding: 16px;
}
.elm-book-docs__theming__theme {
    
}
"""


docs : UIChapter x
docs =
    chapter "Theming"
        |> withTwoColumns
        |> withBackgroundColor themeBackground
        |> withElement (div [] [])
        -- (div
        --     [ css
        --         [ displayFlex
        --         , alignItems stretch
        --         , padding (px 16)
        --         , fontDefault
        --         ]
        --     ]
        --     [ div [ css [ Css.width (pct 60) ] ]
        --         [ p
        --             [ style "color" themeAccentAlt
        --             , css [ padding2 zero (px 20) ]
        --             ]
        --             [ text "Theme Accent Alt"
        --             , br [] []
        --             , span [ css [ fontSize (px 12), opacity (num 0.8) ] ]
        --                 [ text "(Theme Background)"
        --                 ]
        --             ]
        --         , div
        --             [ css [ position relative ] ]
        --             [ div
        --                 [ css [ insetZero, opacity (num 0.2) ]
        --                 , style "background-color" themeBackgroundAlt
        --                 ]
        --                 []
        --             , p
        --                 [ css
        --                     [ padding4 (px 8) (px 48) (px 8) (px 20)
        --                     , position relative
        --                     , zIndex (int 1)
        --                     ]
        --                 , style "color" themeAccentAlt
        --                 ]
        --                 [ text "Theme Accent"
        --                 , br [] []
        --                 , span [ css [ fontSize (px 12), opacity (num 0.8) ] ]
        --                     [ text "(Theme Background Alt)"
        --                     ]
        --                 ]
        --             ]
        --         ]
        --     , div
        --         [ css
        --             [ Css.width (pct 40)
        --             , borderRadius (px 4)
        --             , backgroundColor (hex wrapperMainBackground)
        --             ]
        --         ]
        --         []
        --     ]
        -- )
        |> render """
### Header Customizations

<element />

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []

### Colors Themes

    main : ElmBook x
    main =
        book "CustomHeader"
            |> withSubtitle "Custom Subtitle"
            |> withLogo (img [ src "/mycompanylogo.png" ] [])
            |> withChapters []        
"""
