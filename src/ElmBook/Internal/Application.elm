module ElmBook.Internal.Application exposing
    ( BookApplication
    , Model
    , application
    , init
    )

import Array exposing (Array)
import Browser
import Browser.Dom
import Browser.Events exposing (onKeyDown, onKeyUp)
import Browser.Navigation
import Dict
import ElmBook.Chapter exposing (chapter)
import ElmBook.Internal.Book exposing (BookBuilder, ElmBookConfig, chapterFromUrl, configFromBuilder)
import ElmBook.Internal.Chapter exposing (ChapterComponentView(..), ChapterCustom(..), chapterBreadcrumb, chapterInternal, chapterNavUrl, chapterTitle, chapterUrl)
import ElmBook.Internal.ComponentOptions
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.ThemeOptions exposing (hashBasedNavigation, navBackground)
import ElmBook.UI.ActionLog
import ElmBook.UI.Chapter
import ElmBook.UI.ChapterHeader
import ElmBook.UI.Footer
import ElmBook.UI.Header
import ElmBook.UI.Nav
import ElmBook.UI.Search
import ElmBook.UI.Styles
import ElmBook.UI.Wrapper
import Html exposing (Html, text)
import Json.Decode as Decode
import Task
import Url



-- Model


type alias Model state html =
    { navKey : Browser.Navigation.Key
    , url : String
    , state : Maybe state
    , themeOverrides : ElmBook.Internal.ThemeOptions.ThemeOptionOverrides
    , chapterPreSelected : Int
    , darkMode : Bool
    , search : String
    , isSearching : Bool
    , isShiftPressed : Bool
    , isMetaPressed : Bool
    , actionLog : List ( String, String )
    , actionLogModal : Bool
    , isMenuOpen : Bool
    , backCompatibility : Maybe html
    }



-- Application


type alias BookApplication state html =
    Program () (Model state html) (Msg state)


application :
    List ( String, List (ChapterCustom state html) )
    -> BookBuilder state html
    -> BookApplication state html
application chapterGroups bookBuilder =
    let
        config =
            configFromBuilder chapterGroups bookBuilder
    in
    Browser.application
        { init = init config
        , view = view config
        , update =
            \msg model ->
                update config msg model
                    |> withActionLogReset model
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        , subscriptions =
            \_ ->
                Sub.batch
                    [ onKeyDown keyDownDecoder
                    , onKeyUp keyUpDecoder
                    , Sub.batch config.statefulOptions.subscriptions
                    ]
        }



-- Init


init :
    ElmBookConfig state html
    -> ()
    -> Url.Url
    -> Browser.Navigation.Key
    -> ( Model state html, Cmd (Msg state) )
init config _ url_ navKey =
    let
        url =
            extractPath config.themeOptions.hashBasedNavigation url_

        darkMode =
            config.themeOptions.preferDarkMode

        initialState =
            config.statefulOptions.initialState
                |> Maybe.map (config.statefulOptions.onDarkModeChange darkMode)

        hashBasedNavigation_ =
            hashBasedNavigation config.themeOptions

        activeChapter =
            chapterFromUrl config (extractPath hashBasedNavigation_ url_)

        ( initialState_, cmd ) =
            activeChapter
                |> Maybe.andThen
                    (\chapter ->
                        Maybe.map2
                            (\state_ chapterInit -> chapterInit state_)
                            initialState
                            (ElmBook.Internal.Chapter.init chapter)
                            |> Maybe.map (Tuple.mapFirst Just)
                    )
                |> Maybe.withDefault ( initialState, Cmd.none )
    in
    ( { navKey = navKey
      , url = url
      , state = initialState_
      , themeOverrides = ElmBook.Internal.ThemeOptions.defaultOverrides
      , darkMode = darkMode
      , chapterPreSelected = 0
      , search = ""
      , isSearching = False
      , isShiftPressed = False
      , isMetaPressed = False
      , actionLog = []
      , actionLogModal = False
      , isMenuOpen = False
      , backCompatibility = Nothing
      }
    , case activeChapter of
        Just _ ->
            cmd

        Nothing ->
            Array.get 0 config.chapters
                |> Maybe.map (Browser.Navigation.replaceUrl navKey << chapterNavUrl hashBasedNavigation_)
                |> Maybe.withDefault (Browser.Navigation.replaceUrl navKey "/")
    )



-- Update


update : ElmBookConfig state html -> Msg state -> Model state html -> ( Model state html, Cmd (Msg state) )
update config msg model =
    let
        activeChapter =
            chapterFromUrl config model.url

        defaultLogContext =
            activeChapter
                |> Maybe.map chapterTitle
                |> Maybe.map (\s -> s ++ " / ")
                |> Maybe.withDefault ""

        logAction_ context action =
            ( { model | actionLog = ( context, action ) :: model.actionLog }
            , Cmd.none
            )

        hashBasedNavigation_ =
            hashBasedNavigation config.themeOptions
    in
    case msg of
        OnUrlRequest request ->
            case request of
                Browser.External url ->
                    ( model, Browser.Navigation.load url )

                Browser.Internal url ->
                    if String.contains "/logAction" url.path then
                        String.replace "/logAction" "" url.path
                            |> (++) "Navigate to: "
                            |> logAction_ defaultLogContext

                    else
                        ( model
                        , Browser.Navigation.pushUrl model.navKey (Url.toString url)
                        )

        OnUrlChange url_ ->
            let
                url =
                    extractPath hashBasedNavigation_ url_
            in
            case url of
                "/" ->
                    Array.get 0 config.chapters
                        |> Maybe.map (\fallback -> ( model, Browser.Navigation.pushUrl model.navKey <| chapterUrl fallback ))
                        |> Maybe.withDefault ( { model | url = "/" }, Cmd.none )

                _ ->
                    let
                        urlChapter =
                            Dict.get url config.chapterByUrl
                                |> Maybe.andThen (\i -> Array.get i config.chapters)
                    in
                    case urlChapter of
                        Just chapter ->
                            let
                                ( state, cmd ) =
                                    Maybe.map2
                                        (\state_ chapterInit -> chapterInit state_)
                                        model.state
                                        (ElmBook.Internal.Chapter.init chapter)
                                        |> Maybe.map (Tuple.mapFirst Just)
                                        |> Maybe.withDefault ( model.state, Cmd.none )
                            in
                            ( { model
                                | url = url
                                , isMenuOpen = False
                                , state = state
                              }
                            , Cmd.batch
                                [ cmd
                                , Task.attempt
                                    (\_ -> DoNothing)
                                    (Browser.Dom.setViewportOf "elm-book-main" 0 0)
                                ]
                            )

                        Nothing ->
                            ( { model
                                | url = url
                                , isMenuOpen = False
                              }
                            , Browser.Navigation.replaceUrl model.navKey
                                (if hashBasedNavigation_ then
                                    "#/"

                                 else
                                    "/"
                                )
                            )

        ToggleDarkMode ->
            let
                darkMode =
                    not model.darkMode
            in
            ( { model
                | darkMode = darkMode
                , state =
                    model.state
                        |> Maybe.map (config.statefulOptions.onDarkModeChange darkMode)
              }
            , Cmd.none
            )

        UpdateState fn ->
            model.state
                |> Maybe.map fn
                |> Maybe.map (Tuple.mapFirst (\s -> { model | state = Just s }))
                |> Maybe.withDefault ( model, Cmd.none )

        LogAction context action ->
            logAction_ context action

        ActionLogShow ->
            ( { model | actionLogModal = True }, Cmd.none )

        ActionLogHide ->
            ( { model | actionLogModal = False }, Cmd.none )

        SearchFocus ->
            ( { model | isSearching = True, chapterPreSelected = 0 }, Cmd.none )

        SearchBlur ->
            ( { model
                | isSearching = False
                , search = ""
              }
            , Cmd.none
            )

        Search value ->
            ( { model
                | search = value
                , chapterPreSelected = 0
              }
            , Cmd.none
            )

        ToggleMenu ->
            ( { model | isMenuOpen = not model.isMenuOpen }
            , Cmd.none
            )

        KeyArrowDown ->
            ( { model
                | chapterPreSelected = model.chapterPreSelected + 1
              }
            , Cmd.none
            )

        KeyArrowUp ->
            ( { model | chapterPreSelected = model.chapterPreSelected - 1 }
            , Cmd.none
            )

        KeyShiftOn ->
            ( { model | isShiftPressed = True }, Cmd.none )

        KeyShiftOff ->
            ( { model | isShiftPressed = False }, Cmd.none )

        KeyMetaOn ->
            ( { model | isMetaPressed = True }, Cmd.none )

        KeyMetaOff ->
            ( { model | isMetaPressed = False }, Cmd.none )

        KeyK ->
            if model.isMetaPressed then
                ( model, Task.attempt (\_ -> DoNothing) (Browser.Dom.focus "elm-book-search") )

            else
                ( model, Cmd.none )

        KeyEnter ->
            if not model.isSearching then
                ( model, Cmd.none )

            else
                let
                    preSelectedIndex =
                        modBy (Array.length config.chapters) model.chapterPreSelected

                    targetChapter =
                        Array.get preSelectedIndex config.chapters
                in
                case targetChapter of
                    Just chapter_ ->
                        if chapterInternal chapter_ then
                            ( model
                            , Browser.Navigation.pushUrl
                                model.navKey
                                (chapterNavUrl hashBasedNavigation_ chapter_)
                            )

                        else
                            ( model
                            , Browser.Navigation.load (chapterUrl chapter_)
                            )

                    Nothing ->
                        ( model, Cmd.none )

        SetThemeBackgroundGradient startColor endColor ->
            updateThemeOverrides model
                (\t ->
                    { t
                        | background =
                            Just <|
                                "linear-gradient(150deg, "
                                    ++ startColor
                                    ++ " 0%, "
                                    ++ endColor
                                    ++ " 100%)"
                    }
                )

        SetThemeBackground background ->
            updateThemeOverrides model
                (\t -> { t | background = Just background })

        SetThemeAccent accent ->
            updateThemeOverrides model
                (\t -> { t | accent = Just accent })

        SetThemeNavBackground navBackground ->
            updateThemeOverrides model
                (\t -> { t | navBackground = Just navBackground })

        SetThemeNavAccent navAccent ->
            updateThemeOverrides model
                (\t -> { t | navAccent = Just navAccent })

        SetThemeNavAccentHighlight navAccentHighlight ->
            updateThemeOverrides model
                (\t -> { t | navAccentHighlight = Just navAccentHighlight })

        DoNothing ->
            ( model, Cmd.none )


updateThemeOverrides :
    Model state html
    -> (ElmBook.Internal.ThemeOptions.ThemeOptionOverrides -> ElmBook.Internal.ThemeOptions.ThemeOptionOverrides)
    -> ( Model state html, Cmd (Msg state) )
updateThemeOverrides model fn =
    ( { model | themeOverrides = fn model.themeOverrides }, Cmd.none )


withActionLogReset : Model state html -> ( Model state html, Cmd (Msg state) ) -> ( Model state html, Cmd (Msg state) )
withActionLogReset previousModel =
    Tuple.mapFirst
        (\model ->
            if model.url /= previousModel.url then
                { model | actionLog = [] }

            else
                model
        )



-- View


view : ElmBookConfig state html -> Model state html -> Browser.Document (Msg state)
view config model =
    let
        theme =
            ElmBook.Internal.ThemeOptions.applyOverrides
                config.themeOptions
                model.themeOverrides

        activeChapter =
            chapterFromUrl config model.url

        hashBasedNavigation =
            ElmBook.Internal.ThemeOptions.hashBasedNavigation config.themeOptions
    in
    { title =
        let
            mainTitle =
                ElmBook.Internal.ThemeOptions.subtitle config.themeOptions
                    |> Maybe.map (\s -> config.title ++ " | " ++ s)
                    |> Maybe.withDefault config.title
        in
        case activeChapter of
            Just (Chapter { title }) ->
                title ++ " - " ++ mainTitle

            Nothing ->
                mainTitle
    , body =
        [ ElmBook.UI.Styles.view
        , ElmBook.UI.Wrapper.view
            { theme = theme
            , darkMode = model.darkMode
            , isMenuOpen = model.isMenuOpen
            , globals =
                config.themeOptions.globals
                    |> Maybe.withDefault []
                    |> List.map config.toHtml
            , header =
                ElmBook.UI.Header.view
                    { toHtml = config.toHtml
                    , href = "/"
                    , theme = config.themeOptions
                    , title = config.title
                    , isMenuOpen = model.isMenuOpen
                    , onClickHeader = DoNothing
                    , onClickMenuButton = ToggleMenu
                    }
            , menuHeader =
                ElmBook.UI.Search.view
                    { value = model.search
                    , onInput = Search
                    , onFocus = SearchFocus
                    , onBlur = SearchBlur
                    }
            , menu =
                let
                    chaptersList =
                        searchChapters model.search config.chapters

                    chaptersListSlugs =
                        chaptersList
                            |> Array.toList
                            |> List.map (chapterNavUrl hashBasedNavigation)
                in
                ElmBook.UI.Nav.view
                    { active =
                        activeChapter
                            |> Maybe.map (chapterNavUrl hashBasedNavigation)
                    , preSelected =
                        if model.isSearching then
                            Array.get
                                (modBy (Array.length chaptersList) model.chapterPreSelected)
                                chaptersList
                                |> Maybe.map (chapterNavUrl hashBasedNavigation)

                        else
                            Nothing
                    , itemGroups =
                        config.chapterGroups
                            |> List.map
                                (Tuple.mapSecond
                                    (List.map (\index -> Array.get index config.chapters)
                                        >> List.filterMap identity
                                        >> List.map (\((Chapter { title, internal }) as chapter) -> ( chapterNavUrl hashBasedNavigation chapter, title, internal ))
                                        >> List.filter (\( slug, _, _ ) -> List.member slug chaptersListSlugs)
                                    )
                                )
                    }
            , menuFooter = ElmBook.UI.Footer.view
            , mainHeader =
                activeChapter
                    |> Maybe.map
                        (\chapter ->
                            ElmBook.UI.ChapterHeader.view
                                { title = chapterBreadcrumb chapter
                                , onToggleDarkMode = ToggleDarkMode
                                }
                        )
            , main =
                activeChapter
                    |> Maybe.map
                        (\(Chapter activeChapter_) ->
                            ElmBook.UI.Chapter.view
                                { title = activeChapter_.title
                                , chapterOptions =
                                    activeChapter_.chapterOptions
                                        |> ElmBook.Internal.Chapter.toValidOptions
                                            config.chapterOptions
                                , componentOptions =
                                    activeChapter_.componentOptions
                                        |> ElmBook.Internal.ComponentOptions.toValidOptions
                                            config.componentOptions
                                , body = activeChapter_.body
                                , components =
                                    activeChapter_.componentList
                                        |> List.map
                                            (\component ->
                                                ( component.label
                                                , componentView config.toHtml model.state component.view
                                                )
                                            )
                                }
                        )
                    |> Maybe.withDefault (text "")
            , mainFooter =
                List.head model.actionLog
                    |> Maybe.map
                        (\lastAction ->
                            ElmBook.UI.ActionLog.preview
                                { lastActionIndex = List.length model.actionLog
                                , lastAction = lastAction
                                , onClick = ActionLogShow
                                }
                        )
                    |> Maybe.withDefault ElmBook.UI.ActionLog.previewEmpty
            , modal =
                if model.actionLogModal then
                    Just <|
                        ElmBook.UI.ActionLog.list model.actionLog

                else
                    Nothing
            , onCloseModal = ActionLogHide
            }
        ]
    }


componentView :
    (html -> Html (Msg state))
    -> Maybe state
    -> ChapterComponentView state html
    -> Html (Msg state)
componentView toHtml state_ componentView_ =
    case componentView_ of
        ChapterComponentViewStateless html ->
            toHtml html

        ChapterComponentViewStateful html ->
            state_
                |> Maybe.map (toHtml << html)
                |> Maybe.withDefault
                    (text "")



-- Search


searchChapters : String -> Array (ChapterCustom state html) -> Array (ChapterCustom state html)
searchChapters search chapters =
    case search of
        "" ->
            chapters

        _ ->
            let
                searchLowerCase =
                    String.toLower search

                titleMatchesSearch (Chapter { title }) =
                    String.contains searchLowerCase (String.toLower title)
            in
            Array.filter titleMatchesSearch chapters



-- Routing


extractPath : Bool -> Url.Url -> String
extractPath hashBasedNavigation url =
    if hashBasedNavigation then
        url.fragment |> Maybe.withDefault "/"

    else
        url.path



-- Keyboard Events


keyDownDecoder : Decode.Decoder (Msg state)
keyDownDecoder =
    Decode.map
        (\string ->
            case String.toLower string of
                "arrowdown" ->
                    KeyArrowDown

                "arrowup" ->
                    KeyArrowUp

                "shift" ->
                    KeyShiftOn

                "meta" ->
                    KeyMetaOn

                "enter" ->
                    KeyEnter

                "k" ->
                    KeyK

                _ ->
                    DoNothing
        )
        (Decode.field "key" Decode.string)


keyUpDecoder : Decode.Decoder (Msg state)
keyUpDecoder =
    Decode.map
        (\string ->
            case String.toLower string of
                "shift" ->
                    KeyShiftOff

                "meta" ->
                    KeyMetaOff

                _ ->
                    DoNothing
        )
        (Decode.field "key" Decode.string)
