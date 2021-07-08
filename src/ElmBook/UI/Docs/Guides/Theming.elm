module ElmBook.UI.Docs.Guides.Theming exposing
    ( Model
    , docs
    , init
    )

import ElmBook.Actions exposing (logAction, updateStateWithCmdWith)
import ElmBook.Chapter exposing (Chapter, chapter, render, withComponentList, withComponentOptions, withStatefulComponentList)
import ElmBook.Component
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.Theme exposing (defaultTheme)
import ElmBook.Theme
import ElmBook.UI.Header
import ElmBook.UI.Helpers exposing (css_, themeBackground)
import ElmBook.UI.Icons exposing (iconElm)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task


type alias SharedState m =
    { m | theming : Model }


init : Model
init =
    { backgroundStart = ElmBook.Internal.Theme.defaultBackgroundStart
    , backgroundEnd = ElmBook.Internal.Theme.defaultBackgroundEnd
    , accent = ElmBook.Internal.Theme.defaultAccent
    }


type alias Model =
    { backgroundStart : String
    , backgroundEnd : String
    , accent : String
    }


type Msg
    = UpdateBackgroundStart String
    | UpdateBackgroundEnd String
    | UpdateAccent_ String


update : Msg -> SharedState m -> ( SharedState m, Cmd (ElmBook.Internal.Msg.Msg (SharedState m)) )
update msg sharedState =
    let
        model =
            sharedState.theming

        ( model_, cmd ) =
            case msg of
                UpdateBackgroundStart v ->
                    ( { model | backgroundStart = v }
                    , Task.perform
                        (\_ -> SetThemeBackgroundGradient v model.backgroundEnd)
                        (Task.succeed ())
                    )

                UpdateBackgroundEnd v ->
                    ( { model | backgroundEnd = v }
                    , Task.perform
                        (\_ -> SetThemeBackgroundGradient model.backgroundStart v)
                        (Task.succeed ())
                    )

                UpdateAccent_ v ->
                    ( { model | accent = v }
                    , Task.perform
                        (\_ -> SetThemeAccent v)
                        (Task.succeed ())
                    )
    in
    ( { sharedState | theming = model_ }, cmd )


docs : Chapter (SharedState m)
docs =
    let
        headerProps =
            { href = "/x"
            , theme =
                defaultTheme
                    |> ElmBook.Theme.subtitle "Custom Subtitle"
            , title = "Title"
            , isMenuOpen = False
            , onClickHeader = logAction "onClickHeader"
            , onClickMenuButton = logAction "onClickMenuButton"
            }

        customHeader =
            div
                [ style "font-size" "28px"
                , style "color" "#75c5f0"
                ]
                [ text "Custom" ]
    in
    chapter "Theming"
        |> withComponentOptions
            [ ElmBook.Component.background themeBackground
            ]
        |> withComponentList
            [ ( "Header with custom logo"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.Theme.logo
                                (iconElm { size = 28, color = "#75c5f0" })
                                headerProps.theme
                    }
              )
            , ( "Custom header"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.Theme.header
                                customHeader
                                headerProps.theme
                    }
              )
            ]
        |> withStatefulComponentList
            [ ( "Theme Builder"
              , \{ theming } ->
                    div
                        [ class "elm-book-theme-builder elm-book-shadows-light" ]
                        [ css_ """
.elm-book-theme-builder {
    background-color: #f5f5f5;
    border-radius: 4px;
    border: 1px solid #eaeaea;
    color: #333;
}

.elm-book-theme-builder__field {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
}
.elm-book-theme-builder__field + .elm-book-theme-builder__field {
    border-top: 1px solid #dadada;
}
                    """
                        , label [ class "elm-book-theme-builder__field" ]
                            [ p [ class "elm-book-sans" ] [ text "Background Start" ]
                            , input
                                [ type_ "color"
                                , value theming.backgroundStart
                                , onInput (updateStateWithCmdWith (update << UpdateBackgroundStart))
                                ]
                                []
                            ]
                        , label [ class "elm-book-theme-builder__field" ]
                            [ p [ class "elm-book-sans" ] [ text "Background End" ]
                            , input
                                [ type_ "color"
                                , value theming.backgroundEnd
                                , onInput (updateStateWithCmdWith (update << UpdateBackgroundEnd))
                                ]
                                []
                            ]
                        , label [ class "elm-book-theme-builder__field" ]
                            [ p [ class "elm-book-sans" ] [ text "Accent" ]
                            , input
                                [ type_ "color"
                                , value theming.accent
                                , onInput (updateStateWithCmdWith (update << UpdateAccent_))
                                ]
                                []
                            ]
                        ]
              )
            ]
        |> render ("""
Your book should look and feel your own, so ElmBook provides a few ways you can customize it's theme.

## Custom Colors

I mean… we all love Elm's light blue but maybe it doesn't fit your book. Don't fret, you can customize a lot of what you're seeing.

<component
    with-label="Theme Builder"
    with-display="block"
    />

    main : Book x
    main =
        book "CustomHeader"
            |> withThemeOptions
                [ ElmBook.Theme.background "slategray"
                , ElmBook.Theme.accent "white"
                ]
            |> withChapters [] 

## Custom Header

You can choose a different logo, title and subtitle for your book:

<component with-label="Header with custom logo" with-background=\"""" ++ themeBackground ++ """" />

    main : Book x
    main =
        book "CustomHeader"
            |> withThemeOptions
                [ ElmBook.Theme.subtitle "Custom Subtitle",
                , ElmBook.Theme.logo (img [ src "/mycompanylogo.png" ] [])
                ]
            |> withChapters []

Or you can go full custom and provide your own thing:

<component with-label="Custom header" with-background=\"""" ++ themeBackground ++ """" />

```elm
main : Book x
main =
    book "CustomHeader"
        |> withThemeOptions
            [ ElmBook.Theme.header myCustomHeader
            ]
        |> withChapters []


myCustomHeader : Html msg
myCustomHeader =
    ...
```       

---

## Theming Roadmap

There is a plan to also enable custom fonts soon. Other than that, I believe changes will be less customizable and will focus more on a better UX for all ElmBooks. Things like ready-to-be-used components like Placeholders, Design Tokens Catalogue, etc, should be handled on separate packages.

""")
