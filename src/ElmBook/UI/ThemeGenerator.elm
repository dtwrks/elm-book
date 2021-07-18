module ElmBook.UI.ThemeGenerator exposing (SharedState, view)

import ElmBook.Actions exposing (updateStateWithCmdWith)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.UI.Helpers exposing (css_, mediaMobile)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Task


type alias SharedState m =
    { m | theming : Model }


type alias Model =
    { backgroundStart : String
    , backgroundEnd : String
    , accent : String
    , navBackground : String
    , navAccent : String
    , navAccentHighlight : String
    }


type Msg_
    = UpdateBackgroundStart String
    | UpdateBackgroundEnd String
    | UpdateAccent_ String
    | UpdateNavBackground_ String
    | UpdateNavAccent_ String
    | UpdateNavAccentHighlight_ String


update : Msg_ -> SharedState m -> ( SharedState m, Cmd (ElmBook.Internal.Msg.Msg (SharedState m)) )
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


view : SharedState m -> Html (Msg (SharedState m))
view { theming } =
    div
        [ class "elm-book-theme-builder" ]
        [ css_ <| """
            .elm-book-theme-builder {
                background-color: #fafafa;
                border-radius: 4px;
                border: 1px solid #eaeaea;
                color: #3a3a3a;
            }

            .elm-book-theme-builder__field {
                position: relative;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 20px 8px 28px;
            }
            .elm-book-theme-builder__field:nth-child(2n) {
                background-color: #f5f5f5;
            }
            .elm-book-theme-sample {
                position: absolute;
                width: 6px;
                top: 1px;
                left: 1px;
                bottom: 1px;
            }
            .elm-book-theme-builder__label {
                line-height: 1em;
                padding-right: 4px;
                word-break: break-word;
            }
            .elm-book-theme-builder__label__title {
                font-weight: bold;
                font-size: 14px;
                letter-spacing: 1px;
                margin: 0;
                padding: 0;
            }
            .elm-book-theme-builder__label__subtitle {
                font-size: 12px;
                margin: 0;
                padding-top: 4px;
                color: #999;
            }
            .elm-book-theme-builder__picker-wrapper {
                flex-shrink: 0;
                display: flex;
                align-items: center;
            }
            .elm-book-theme-builder__value {
                font-size: 14px;
                padding-right: 12px;
                color: #999;
                line-height: 1em;
            }
            .elm-book-theme-builder__picker {
                width: 20px;
                height: 20px;
                border-radius: 100%;
                border: none;
                background-color: #e0e0e0;
            }
            """ ++ mediaMobile ++ """ {
                .elm-book-theme-builder__field {
                    flex-direction: column-reverse;
                    align-items: flex-start;
                }
                .elm-book-theme-builder__picker-wrapper {
                    flex-direction: row-reverse;
                    align-items: center;
                    padding-bottom: 4px;
                }
                .elm-book-theme-builder__value {
                    padding-right: 0;
                    padding-left: 8px;
                    font-size: 12px;
                }
            }
                    """
        , div []
            ([ ( ( "backgroundGradient (Start)", "ElmBook.ThemeOptions.backgroundGradient" )
               , theming.backgroundStart
               , UpdateBackgroundStart
               )
             , ( ( "backgroundGradient (End)", "ElmBook.ThemeOptions.backgroundGradient" )
               , theming.backgroundEnd
               , UpdateBackgroundEnd
               )
             , ( ( "accent", "ElmBook.ThemeOptions.accent" )
               , theming.accent
               , UpdateAccent_
               )
             , ( ( "navBackground", "ElmBook.ThemeOptions.navBackground" )
               , theming.navBackground
               , UpdateNavBackground_
               )
             , ( ( "navAccent", "ElmBook.ThemeOptions.navAccent" )
               , theming.navAccent
               , UpdateNavAccent_
               )
             , ( ( "navAccentHighlight", "ElmBook.ThemeOptions.navAccentHighlight" )
               , theming.navAccentHighlight
               , UpdateNavAccentHighlight_
               )
             ]
                |> List.map
                    (\( ( title, subtitle ), value_, msg_ ) ->
                        label
                            [ class "elm-book-theme-builder__field" ]
                            [ div
                                [ class "elm-book-theme-sample"
                                , style "background-color" value_
                                ]
                                []
                            , div [ class "elm-book-theme-builder__label" ]
                                [ p [ class "elm-book-theme-builder__label__title elm-book-sans" ]
                                    [ text title ]
                                , p [ class "elm-book-theme-builder__label__subtitle elm-book-monospace" ]
                                    [ text subtitle ]
                                ]
                            , div [ class "elm-book-theme-builder__picker-wrapper" ]
                                [ p [ class "elm-book-theme-builder__value elm-book-monospace" ] [ text value_ ]
                                , input
                                    [ type_ "color"
                                    , class "elm-book-theme-builder__picker"
                                    , value value_
                                    , onInput (updateStateWithCmdWith (update << msg_))
                                    ]
                                    []
                                ]
                            ]
                    )
            )
        ]
