module ElmBook.UI.Icons exposing (..)

import Html exposing (Html)
import Svg exposing (path, rect, svg)
import Svg.Attributes


type alias IconProps =
    { size : Int
    , color : String
    }


iconGithub : IconProps -> Html msg
iconGithub props =
    svg
        [ Svg.Attributes.width <| String.fromInt props.size
        , Svg.Attributes.height <| String.fromInt props.size
        , Svg.Attributes.viewBox "0 0 512 512"
        ]
        [ path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M256 0C115.39 0 0 115.39 0 256c0 119.988 84.195 228.984 196 256v-84.695c-11.078 2.425-21.273 2.496-32.55-.828-15.13-4.465-27.423-14.543-36.548-29.91-5.816-9.813-16.125-20.454-26.879-19.672l-2.636-29.883c23.254-1.992 43.37 14.168 55.312 34.23 5.305 8.922 11.41 14.153 19.246 16.465 7.575 2.23 15.707 1.16 25.184-2.187 2.379-18.973 11.07-26.075 17.637-36.075v-.015c-66.68-9.946-93.254-45.32-103.801-73.242-13.977-37.075-6.477-83.391 18.238-112.66.48-.571 1.348-2.063 1.012-3.106-11.332-34.23 2.476-62.547 2.984-65.55 13.078 3.866 15.203-3.892 56.809 21.386l7.191 4.32c3.008 1.793 2.063.77 5.07.543 17.372-4.719 35.684-7.324 53.727-7.558 18.18.234 36.375 2.84 54.465 7.75l2.328.234c-.203-.031.633-.149 2.035-.984 51.973-31.481 50.106-21.192 64.043-25.723.504 3.008 14.13 31.785 2.918 65.582-1.512 4.656 45.059 47.3 19.246 115.754-10.547 27.933-37.117 63.308-103.797 73.254v.015c8.547 13.028 18.817 19.957 18.762 46.832V512c111.809-27.016 196-136.012 196-256C512 115.39 396.61 0 256 0zm0 0" ] []
        ]


iconElm : IconProps -> Html msg
iconElm props =
    svg
        [ Svg.Attributes.width <| String.fromInt props.size
        , Svg.Attributes.height <| String.fromInt props.size
        , Svg.Attributes.viewBox "0 0 256 256"
        ]
        [ path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M128 135.022L7.023 256h241.955z" ] [] -- #5FB4CB
        , path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M202.332 195.311L256 248.98V141.643z" ] [] -- #EEA400
        , path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M120.978 128L0 7.022V248.98z" ] [] -- #596277
        , path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M256 113.806V0H142.193z" ] [] -- #5FB4CB
        , path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M195.584 67.434l60.288 60.289l-60.563 60.564l-60.29-60.29z" ] [] -- #8CD636
        , path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M7.021 0l55.725 55.726h121.13L128.15 0z" ] [] -- #8CD636
        , path [ Svg.Attributes.fill props.color, Svg.Attributes.d "M128 120.979l55.322-55.323H72.677z" ] [] -- #EEA400
        ]


iconElmColor : Int -> Html msg
iconElmColor size =
    svg
        [ Svg.Attributes.width <| String.fromInt size
        , Svg.Attributes.height <| String.fromInt size
        , Svg.Attributes.viewBox "0 0 256 256"
        ]
        [ path [ Svg.Attributes.fill "#5FB4CB", Svg.Attributes.d "M128 135.022L7.023 256h241.955z" ] []
        , path [ Svg.Attributes.fill "#EEA400", Svg.Attributes.d "M202.332 195.311L256 248.98V141.643z" ] []
        , path [ Svg.Attributes.fill "#596277", Svg.Attributes.d "M120.978 128L0 7.022V248.98z" ] []
        , path [ Svg.Attributes.fill "#5FB4CB", Svg.Attributes.d "M256 113.806V0H142.193z" ] []
        , path [ Svg.Attributes.fill "#8CD636", Svg.Attributes.d "M195.584 67.434l60.288 60.289l-60.563 60.564l-60.29-60.29z" ] []
        , path [ Svg.Attributes.fill "#8CD636", Svg.Attributes.d "M7.021 0l55.725 55.726h121.13L128.15 0z" ] []
        , path [ Svg.Attributes.fill "#EEA400", Svg.Attributes.d "M128 120.979l55.322-55.323H72.677z" ] []
        ]


iconMenu : IconProps -> Html msg
iconMenu props =
    svg
        [ Svg.Attributes.width <| String.fromInt props.size
        , Svg.Attributes.height <| String.fromInt props.size
        , Svg.Attributes.viewBox "0 0 512 512"
        ]
        [ path
            [ Svg.Attributes.fill props.color
            , Svg.Attributes.d "M176.792 0H59.208C26.561 0 0 26.561 0 59.208v117.584C0 209.439 26.561 236 59.208 236h117.584C209.439 236 236 209.439 236 176.792V59.208C236 26.561 209.439 0 176.792 0zM196 176.792c0 10.591-8.617 19.208-19.208 19.208H59.208C48.617 196 40 187.383 40 176.792V59.208C40 48.617 48.617 40 59.208 40h117.584C187.383 40 196 48.617 196 59.208v117.584zM452 0H336c-33.084 0-60 26.916-60 60v116c0 33.084 26.916 60 60 60h116c33.084 0 60-26.916 60-60V60c0-33.084-26.916-60-60-60zm20 176c0 11.028-8.972 20-20 20H336c-11.028 0-20-8.972-20-20V60c0-11.028 8.972-20 20-20h116c11.028 0 20 8.972 20 20v116zM176.792 276H59.208C26.561 276 0 302.561 0 335.208v117.584C0 485.439 26.561 512 59.208 512h117.584C209.439 512 236 485.439 236 452.792V335.208C236 302.561 209.439 276 176.792 276zM196 452.792c0 10.591-8.617 19.208-19.208 19.208H59.208C48.617 472 40 463.383 40 452.792V335.208C40 324.617 48.617 316 59.208 316h117.584c10.591 0 19.208 8.617 19.208 19.208v117.584zM452 276H336c-33.084 0-60 26.916-60 60v116c0 33.084 26.916 60 60 60h116c33.084 0 60-26.916 60-60V336c0-33.084-26.916-60-60-60zm20 176c0 11.028-8.972 20-20 20H336c-11.028 0-20-8.972-20-20V336c0-11.028 8.972-20 20-20h116c11.028 0 20 8.972 20 20v116z"
            ]
            []
        ]


iconClose : IconProps -> Html msg
iconClose props =
    svg
        [ Svg.Attributes.width <| String.fromInt props.size
        , Svg.Attributes.height <| String.fromInt props.size
        , Svg.Attributes.viewBox "0 0 512 512"
        ]
        [ path
            [ Svg.Attributes.fill props.color
            , Svg.Attributes.d "M451.792 0H59.208C26.561 0 0 26.561 0 59.208v393.084C0 484.939 26.561 511.5 59.208 511.5h392.584c32.647 0 59.208-26.561 59.208-59.208V59.208C511 26.561 484.439 0 451.792 0zM471 452.292c0 10.591-8.617 19.208-19.208 19.208H59.208C48.617 471.5 40 462.883 40 452.292V59.208C40 48.617 48.617 40 59.208 40h392.584C462.383 40 471 48.617 471 59.208v393.084z"
            ]
            []
        , rect
            [ Svg.Attributes.fill props.color
            , Svg.Attributes.x "105"
            , Svg.Attributes.y "377.943"
            , Svg.Attributes.width "386"
            , Svg.Attributes.height "40"
            , Svg.Attributes.rx "20"
            , Svg.Attributes.transform "rotate(-45 105 377.943)"
            ]
            []
        , rect
            [ Svg.Attributes.fill props.color
            , Svg.Attributes.x "133.284"
            , Svg.Attributes.y "105"
            , Svg.Attributes.width "386"
            , Svg.Attributes.height "40"
            , Svg.Attributes.rx "20"
            , Svg.Attributes.transform "rotate(45 133.284 105)"
            ]
            []
        ]


iconDarkMode : IconProps -> Html msg
iconDarkMode props =
    svg
        [ Svg.Attributes.width <| String.fromInt props.size
        , Svg.Attributes.height <| String.fromInt props.size
        , Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.fill "none"
        , Svg.Attributes.stroke props.color
        , Svg.Attributes.strokeWidth "2"
        , Svg.Attributes.strokeLinecap "round"
        , Svg.Attributes.strokeLinejoin "round"
        ]
        [ path
            [ Svg.Attributes.d "M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"
            ]
            []
        ]
