module ElmBook.UI.Docs.Guides.Theming exposing
    ( Model
    , docs
    , init
    )

import ElmBook.Actions exposing (logAction, updateStateWithCmdWith)
import ElmBook.Chapter exposing (Chapter, chapter, render, withComponentList, withComponentOptions, withStatefulComponentList)
import ElmBook.ComponentOptions
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.Theme exposing (defaultTheme)
import ElmBook.ThemeOptions
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
    , navBackground = ElmBook.Internal.Theme.defaultNavBackground
    , navAccent = ElmBook.Internal.Theme.defaultNavAccent
    , navAccentHighlight = ElmBook.Internal.Theme.defaultNavAccentHighlight
    }


type alias Model =
    { backgroundStart : String
    , backgroundEnd : String
    , accent : String
    , navBackground : String
    , navAccent : String
    , navAccentHighlight : String
    }


type Msg
    = UpdateBackgroundStart String
    | UpdateBackgroundEnd String
    | UpdateAccent_ String
    | UpdateNavBackground_ String
    | UpdateNavAccent_ String
    | UpdateNavAccentHighlight_ String


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

                UpdateNavBackground_ v ->
                    ( { model | navBackground = v }
                    , Task.perform
                        (\_ -> SetThemeNavBackground v)
                        (Task.succeed ())
                    )

                UpdateNavAccent_ v ->
                    ( { model | navAccent = v }
                    , Task.perform
                        (\_ -> SetThemeNavAccent v)
                        (Task.succeed ())
                    )

                UpdateNavAccentHighlight_ v ->
                    ( { model | navAccentHighlight = v }
                    , Task.perform
                        (\_ -> SetThemeNavAccentHighlight v)
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
                    |> ElmBook.ThemeOptions.subtitle "Custom Subtitle"
            , title = "Custom Title"
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
            [ ElmBook.ComponentOptions.background themeBackground
            ]
        |> withComponentList
            [ ( "Header with custom logo"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.ThemeOptions.logo
                                (iconElm { size = 28, color = "#75c5f0" })
                                headerProps.theme
                    }
              )
            , ( "Custom header"
              , ElmBook.UI.Header.view
                    { headerProps
                        | theme =
                            ElmBook.ThemeOptions.header
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
                        , div []
                            ([ ( "backgroundGradient (Start)", theming.backgroundStart, UpdateBackgroundStart )
                             , ( "backgroundGradient (End)", theming.backgroundEnd, UpdateBackgroundEnd )
                             , ( "accent", theming.accent, UpdateAccent_ )
                             , ( "navBackground", theming.navBackground, UpdateNavBackground_ )
                             , ( "navAccent", theming.navAccent, UpdateNavAccent_ )
                             , ( "navAccentHighlight", theming.navAccentHighlight, UpdateNavAccentHighlight_ )
                             ]
                                |> List.map
                                    (\( label_, value_, msg_ ) ->
                                        label
                                            [ class "elm-book-theme-builder__field" ]
                                            [ p [ class "elm-book-sans" ] [ text label_ ]
                                            , input
                                                [ type_ "color"
                                                , value value_
                                                , onInput (updateStateWithCmdWith (update << msg_))
                                                ]
                                                []
                                            ]
                                    )
                            )
                        ]
              )
            ]
        |> render ("""
Your book should look and feel your own, so ElmBook provides a few ways you can customize it's theme.

## Custom Header

You can choose a different logo, title and subtitle for your book:

<component with-label="Header with custom logo" with-background=\"""" ++ themeBackground ++ """" />

    main : Book x
    main =
        book "Custom Title"
            |> withThemeOptions
                [ ElmBook.ThemeOptions.subtitle "Custom Subtitle",
                , ElmBook.ThemeOptions.logo (img [ src "/mycompanylogo.png" ] [])
                ]
            |> withChapters []

Or you can go full custom and provide your own thing:

<component with-label="Custom header" with-background=\"""" ++ themeBackground ++ """" />

```elm
main : Book x
main =
    book "Custom Header"
        |> withThemeOptions
            [ ElmBook.ThemeOptions.header myCustomHeader
            ]
        |> withChapters []


myCustomHeader : Html msg
myCustomHeader =
    ...
```       

---

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
                [ ElmBook.ThemeOptions.background "slategray"
                , ElmBook.ThemeOptions.accent "white"
                ]
            |> withChapters [] 

---

## Roadmap

There is a plan to also enable custom fonts soon. Other than that, I believe changes will be less customizable and will focus more on a better UX for all ElmBooks. Things like ready-to-be-used components like Placeholders, Design Tokens Catalogue, etc, should be handled on separate packages.

""")
