module ElmBook.UI.Wrapper exposing
    ( styles
    , view
    )

import ElmBook.Internal.ThemeOptions
import ElmBook.UI.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view :
    { theme : ElmBook.Internal.ThemeOptions.ThemeOptions html
    , darkMode : Bool
    , globals : List (Html msg)
    , header : Html msg
    , menu : Html msg
    , menuHeader : Html msg
    , menuFooter : Html msg
    , main : Html msg
    , mainHeader : Maybe (Html msg)
    , mainFooter : Html msg
    , modal : Maybe (Html msg)
    , isMenuOpen : Bool
    , onCloseModal : msg
    }
    -> Html msg
view props =
    div
        [ setTheme props.theme
        , if props.darkMode then
            class "elm-book-dark-mode"

          else
            class ""
        ]
        [ div [ class "elm-book--wrapper--globals" ] props.globals
        , div
            [ classList
                [ ( "elm-book--wrapper elm-book-inset", True )
                , ( "is-open", props.isMenuOpen )
                ]
            ]
            [ -- Sidebar
              div [ class "elm-book--wrapper--sidebar" ]
                [ -- Header
                  div [ class "elm-book--wrapper--header" ]
                    [ props.header ]
                , -- Menu
                  div
                    [ class "elm-book--wrapper--menu" ]
                    [ -- Menu Header
                      div
                        [ class "elm-book--wrapper--menu--header" ]
                        [ props.menuHeader ]
                    , hr [ class "elm-book--wrapper--menu--separator" ] []
                    , -- Menu Main
                      div
                        [ class "elm-book--wrapper--menu--main-wrapper" ]
                        [ div [ class "elm-book--wrapper--menu--main elm-book-inset" ]
                            [ props.menu ]
                        ]
                    , -- Menu Footer
                      hr [ class "elm-book--wrapper--menu--separator" ] []
                    , div
                        [ class "elm-book--wrapper--menu--footer" ]
                        [ props.menuFooter ]
                    ]
                ]
            , -- Main
              div
                [ class "elm-book--wrapper--main" ]
                [ div [ class "elm-book--wrapper--main--wrapper" ]
                    [ -- Main Header
                      case props.mainHeader of
                        Just mainHeader ->
                            div
                                [ class "elm-book--wrapper--main--header elm-book-sans" ]
                                [ mainHeader ]

                        Nothing ->
                            text ""
                    , -- Main Main
                      div
                        [ class "elm-book--wrapper--main--content" ]
                        [ div
                            [ id "elm-book-main"
                            , class "elm-book--wrapper--main--inner elm-book-inset"
                            ]
                            [ props.main ]
                        ]
                    , -- Main Footer
                      div
                        [ class "elm-book--wrapper--main--footer" ]
                        [ props.mainFooter ]
                    ]
                ]
            ]
        , case props.modal of
            Just html ->
                div
                    [ class "elm-book-inset elm-book-fade-in elm-book--wrapper--modal" ]
                    [ div
                        [ onClick props.onCloseModal
                        , class "elm-book-inset elm-book--wrapper--modal--bg"
                        ]
                        []
                    , div
                        [ class "elm-book--wrapper--modal--content elm-book-shadows" ]
                        [ html ]
                    ]

            Nothing ->
                text ""
        ]



-- Helpers


sidebarSize : String
sidebarSize =
    "300px"


modalZ : String
modalZ =
    "99999"



-- Styles


styles : Html msg
styles =
    css_ <| """
.elm-book--wrapper--globals {
    display: none;
}

.elm-book--wrapper {
    display: flex;
    align-items: stretch;
    background: """ ++ themeBackground ++ """;
}
""" ++ mediaMobile ++ """ {
    .elm-book--wrapper {
        flex-direction: column;
    }
}

.elm-book--wrapper--sidebar {
    display: flex;
    flex-direction: column;
    width: """ ++ sidebarSize ++ """;
}
""" ++ mediaMobile ++ """ {
    .elm-book--wrapper--sidebar {
        width: 100%;
    }
    .elm-book--wrapper.is-open .elm-book--wrapper--sidebar {
        flex-grow: 1;
    }
}

.elm-book--wrapper--header {
    padding: 8px 8px 4px;
}

.elm-book--wrapper--menu {
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}
""" ++ mediaMobile ++ """ {
    .elm-book--wrapper--menu {
        display: none;
    }
    .elm-book--wrapper.is-open .elm-book--wrapper--menu {
        display: flex;
    }
}

.elm-book--wrapper--menu--header {
    padding: 8px;
}

.elm-book--wrapper--menu--separator {
    display: block;
    margin: 0;
    padding: 0;
    opacity: 0.2;
    border-top: none;
    border-bottom: 1px solid """ ++ themeNavBackground ++ """;
}

.elm-book--wrapper--menu--main-wrapper {
    position: relative;
    flex-grow: 1;
}

.elm-book--wrapper--menu--main {
    overflow: auto;
    padding: 8px 0;
}

.elm-book--wrapper--menu--footer {
    padding: 8px;
}

.elm-book--wrapper--main {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    padding: 8px 8px 0 0;
}
""" ++ mediaMobile ++ """ {
    .elm-book--wrapper--main {
        display: flex;
        padding-left: 8px;
    }
    .elm-book--wrapper.is-open .elm-book--wrapper--main {
        display: none;
    }
}

.elm-book--wrapper--main--wrapper {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    background-color: #fbfbfd;
    border-radius: 4px 4px 0 0;
    overflow: hidden;
}
.elm-book-dark-mode .elm-book--wrapper--main--wrapper {
    background-color: #20232a;
}

.elm-book--wrapper--main--header {
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}
.elm-book-dark-mode .elm-book--wrapper--main--header {
    border-bottom-color: rgba(255, 255, 255, 0.15);
}

.elm-book--wrapper--main--content {
    position: relative;
    flex-grow: 1;
}

.elm-book--wrapper--main--inner {
    overflow: auto;
}

.elm-book--wrapper--main--footer {
    border-top: 1px solid rgba(0, 0, 0, 0.1);
}
.elm-book-dark-mode .elm-book--wrapper--main--footer {
    border-top-color: rgba(255, 255, 255, 0.15);
}

.elm-book--wrapper--modal {
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: """ ++ modalZ ++ """;
}

.elm-book--wrapper--modal--bg {
    z-index: 0;
    cursor: pointer;
    background-color: rgba(0, 0, 0, 0.3);
    transition: background-color 300ms;
}
.elm-book--wrapper--modal--bg:hover {
    background-color: rgba(0, 0, 0, 0.2);
}

.elm-book--wrapper--modal--content {
    position: relative;
    z-index: 1;
    margin: 40px;
    width: 640px;
    max-width: 100%;
    max-height: calc 100% - 120px;
    overflow-y: auto;
    background-color: #fff;
    border-radius: 8px;
}
.elm-book-dark-mode .elm-book--wrapper--modal--content {
    background-color: #20232a;
}
"""
