module ElmBook.UI.ActionLog exposing
    ( list
    , preview
    , previewEmpty
    , styles
    )

import ElmBook.UI.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


preview :
    { lastActionIndex : Int
    , lastAction : ( String, String )
    , onClick : msg
    }
    -> Html msg
preview props =
    div
        [ class "elm-book-action-log-preview-wrapper" ]
        [ button
            [ class "elm-book-action-log-preview"
            , onClick props.onClick
            ]
            [ item props.lastActionIndex props.lastAction
            ]
        ]


previewEmpty : Html msg
previewEmpty =
    div
        [ class "elm-book-monospace elm-book-action-log-preview-empty-wrapper" ]
        [ div [ class "elm-book-action-log-preview-empty" ]
            [ text "Your logged actions will appear here." ]
        ]


list : List ( String, String ) -> Html msg
list props =
    div [ class "elm-book elm-book-action-log-list-wrapper" ]
        [ p
            [ class "elm-book elm-book-action-log-list-header elm-book-sans"
            , style "background" themeBackground
            ]
            [ text "Action log" ]
        , ul
            [ class "elm-book elm-book-action-log-list" ]
            (List.indexedMap item props
                |> List.reverse
                |> List.map
                    (\item_ ->
                        li [ class "elm-book elm-book-action-log-list-item" ]
                            [ item_ ]
                    )
            )
        ]


item : Int -> ( String, String ) -> Html msg
item index ( preffix, label ) =
    div
        [ class "elm-book-wrapper elm-book-action-log-item-wrapper elm-book-monospace" ]
        [ p
            [ class "elm-book-action-log-item-index" ]
            [ text ("(" ++ String.fromInt (index + 1) ++ ")")
            ]
        , div [ class "elm-book-action-log__main" ]
            [ p
                [ class "elm-book-action-log-item-preffix" ]
                [ text preffix ]
            , p [ class "elm-book-action-log-item-label" ] [ text label ]
            ]
        ]


styles : Html msg
styles =
    css_ """
.elm-book-action-log-preview-wrapper {
    padding: 8px;
}
.elm-book-action-log-preview {
    display: block;
    width: 100%;
    padding: 0;
    margin: 0;
    border: none;
    border-radius: 4px;
    background-color: transparent;
    text-align: left;
    font-size: 14px;
    cursor: pointer;
}
.elm-book-action-log-preview:hover {
    opacity: 0.9;
}
.elm-book-action-log-preview:hover {
    opacity: 0.8;
}

.elm-book-action-log-preview-empty-wrapper {
    padding: 8px;
    font-size: 14px;
    color: #aaa;
}
.elm-book-action-log-preview-empty {
    padding: 12px 20px;
    background-color: #f3f3f3;
    border-radius: 4px;
}

.elm-book-dark-mode .elm-book-action-log-preview-empty {
    background-color: #2f3238;
}

.elm-book-action-log-list-wrapper {
    position: relative;
    padding-top: 34px;
}
.elm-book-action-log-list-header {
    display: flex;
    align-items: center;
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 34px;
    padding: 0 20px;
    font-weight: bold;
    font-size: 14px;
    letter-spacing: 0.5px;
    color: #fff;
}
.elm-book-action-log-list {
    list-style-type: none;
    max-height: 70vh;
    overflow-y: auto;
}
.elm-book-action-log-list-item {
    border-top: 1px solid #e0e0e0;
}
.elm-book-dark-mode .elm-book-action-log-list-item {
    border-top-color: #3b3f47;
}

.elm-book-action-log-item-wrapper {
    display: flex;
    align-items: center;
    padding: 8px 20px 8px 0;
    font-size: 14px;
    background-color: #f5f5f5;
}
.elm-book-dark-mode .elm-book-action-log-item-wrapper {
    background-color: #2f3238;
}

.elm-book-action-log-item-index {
    width: 60px;
    text-align: center;
    display: inline-block;
    color: #a0a0a0;
}
.elm-book-action-log__main {
    flex-grow: 1;
}
.elm-book-action-log-item-preffix {
    padding-right: 16px;
    color: #a0a0a0;
    letter-spacing: 0.5px;
    font-size: 12px;
}
.elm-book-action-log-item-label {
    color: #404040;
    font-size: 13px;
    font-weight: bold;
}
.elm-book-dark-mode .elm-book-action-log-item-label {
    color: #f5f5f5;
}
"""
