module ElmBook.UI.Nav exposing
    ( styles
    , view
    )

import ElmBook.UI.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Url.Builder


styles : Html msg
styles =
    css_ """
.elm-book-nav-empty {
    padding: 12px 20px;
    font-size: 14px;
    opacity: 0.6;
}

.elm-book-nav-list-wrapper {
    padding-bottom: 16px;
}

.elm-book-nav-list-title {
    padding: 12px 20px 8px;
    font-weight: bold;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.elm-book-nav-list {
    list-style-type: none;
}

.elm-book-nav-item {
    position: relative;
    display: flex;
    font-size: 14px;
    letter-spacing: 1px;
    text-decoration: none;
}
.elm-book-nav-item:focus {
    outline: none;
}

.elm-book-nav-item-content {
    position: relative;
    z-index: 1;
    padding: 8px 20px;
}

.elm-book-nav-item-bg {
    opacity: 0;
}
.elm-book-nav-item.pre-selected .elm-book-nav-item-bg {
    opacity: 0.1;
}
.elm-book-nav-item.active .elm-book-nav-item-bg {
    opacity: 0.25;
}
.elm-book-nav-item.active.pre-selected .elm-book-nav-item-bg {
    opacity: 0.3;
}
.elm-book-nav-item:hover .elm-book-nav-item-bg {
    opacity: 0.15;
}
.elm-book-nav-item:active .elm-book-nav-item-bg {
    opacity: 0.1;
}
.elm-book-nav-item.active:hover .elm-book-nav-item-bg {
    opacity: 0.3;
}
.elm-book-nav-item.active:active .elm-book-nav-item-bg {
    opacity: 0.25;
}
"""


view :
    { preffix : String
    , active : Maybe String
    , preSelected : Maybe String
    , itemGroups : List ( String, List ( String, String ) )
    }
    -> Html msg
view props =
    let
        isEmpty : Bool
        isEmpty =
            props.itemGroups
                |> List.foldl (\( _, xs ) acc -> acc + List.length xs) 0
                |> (==) 0

        item : ( String, String ) -> Html msg
        item ( slug, label ) =
            li []
                [ a
                    [ classList
                        [ ( "elm-book-nav-item", True )
                        , ( "active", props.active == Just slug )
                        , ( "pre-selected", props.preSelected == Just slug )
                        ]
                    , style "color" themeAccent
                    , href (Url.Builder.absolute [ props.preffix, slug ] [])
                    , if props.active == Just slug then
                        style "opacity" "1"

                      else
                        style "opacity" "0.8"
                    ]
                    [ div
                        [ class "elm-book-inset elm-book-nav-item-bg"
                        , style "background-color" themeBackgroundAlt
                        ]
                        []
                    , div [ class "elm-book-nav-item-content" ]
                        [ text label ]
                    ]
                ]

        list : ( String, List ( String, String ) ) -> Html msg
        list ( title, items ) =
            if List.isEmpty items then
                text ""

            else
                div [ class "elm-book-nav-list-wrapper" ]
                    [ if title == "" then
                        text ""

                      else
                        p
                            [ class "elm-book-nav-list-title"
                            , style "color" themeAccent
                            ]
                            [ text title ]
                    , ul [ class "elm-book-nav-list" ]
                        (List.map item items)
                    ]
    in
    div [ class "elm-book-wrapper elm-book-sans" ]
        [ if isEmpty then
            p
                [ class "elm-book-nav-empty"
                , style "color" themeAccent
                ]
                [ text "No results" ]

          else
            nav [ class "elm-book-nav" ]
                (List.map list props.itemGroups)
        ]
