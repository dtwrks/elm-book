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
import ElmBook.Chapter exposing (chapter)
import ElmBook.Internal.Book exposing (BookBuilder(..), ElmBookConfig)
import ElmBook.Internal.Chapter exposing (ChapterComponentView(..), ChapterCustom(..), chapterBreadcrumb, chapterTitle, chapterUrl)
import ElmBook.Internal.ComponentOptions
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.ThemeOptions exposing (hashBasedNavigation, navBackground)
import ElmBook.ThemeOptions
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
    , config : ElmBookConfig state html
    , chapterGroups : List ( String, List Int )
    , chapters : Array (ChapterCustom state html)
    , chaptersSearched : Array (ChapterCustom state html)
    , chapterActive : Maybe (ChapterCustom state html)
    , chapterPreSelected : Int
    , toggleDarkMode : Bool
    , search : String
    , isSearching : Bool
    , isShiftPressed : Bool
    , isMetaPressed : Bool
    , actionLog : List ( String, String )
    , actionLogModal : Bool
    , isMenuOpen : Bool
    }



-- Application


type alias BookApplication state html =
    Program () (Model state html) (Msg state)


application :
    List ( String, List (ChapterCustom state html) )
    -> BookBuilder state html
    -> BookApplication state html
application chapterGroups (BookBuilder config) =
    Browser.application
        { init =
            init
                { config = config
                , chapterGroups = chapterGroups
                }
        , view = view
        , update =
            \msg model ->
                update msg model
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
    { chapterGroups : List ( String, List (ChapterCustom state html) )
    , config : ElmBookConfig state html
    }
    -> ()
    -> Url.Url
    -> Browser.Navigation.Key
    -> ( Model state html, Cmd (Msg state) )
init props _ url navKey =
    let
        chapters =
            props.chapterGroups
                |> List.foldl
                    (\( _, chapters_ ) acc ->
                        chapters_
                            |> Array.fromList
                            |> Array.append acc
                    )
                    Array.empty

        chapterGroups =
            let
                toIndexedGroup : Int -> ( String, List a ) -> ( String, List Int )
                toIndexedGroup initialIndex ( groupTitle, groupChapters ) =
                    ( groupTitle
                    , List.indexedMap (\i _ -> i + initialIndex) groupChapters
                    )
            in
            props.chapterGroups
                |> List.foldl
                    (\( label, xs ) ( acc, lastIndex ) ->
                        ( toIndexedGroup lastIndex ( label, xs ) :: acc
                        , lastIndex + List.length xs
                        )
                    )
                    ( [], 0 )
                |> Tuple.first
                |> List.reverse

        activeChapter =
            parseActiveChapterFromUrl props.config chapters url
    in
    ( { navKey = navKey
      , config = props.config
      , chapterGroups = chapterGroups
      , chapters = chapters
      , chaptersSearched = chapters
      , chapterActive = activeChapter
      , chapterPreSelected = 0
      , toggleDarkMode = False
      , search = ""
      , isSearching = False
      , isShiftPressed = False
      , isMetaPressed = False
      , actionLog = []
      , actionLogModal = False
      , isMenuOpen = False
      }
    , case activeChapter of
        Just _ ->
            Cmd.none

        Nothing ->
            Array.get 0 chapters
                |> Maybe.map (Browser.Navigation.replaceUrl navKey << chapterUrl (hashBasedNavigation props.config.themeOptions))
                |> Maybe.withDefault (Browser.Navigation.replaceUrl navKey "/")
    )



-- Update


update : Msg state -> Model state html -> ( Model state html, Cmd (Msg state) )
update msg model =
    let
        defaultLogContext =
            model.chapterActive
                |> Maybe.map chapterTitle
                |> Maybe.map (\s -> s ++ " / ")
                |> Maybe.withDefault ""

        logAction_ context action =
            ( { model | actionLog = ( context, action ) :: model.actionLog }
            , Cmd.none
            )

        hashBasedNavigation_ =
            hashBasedNavigation model.config.themeOptions
    in
    case msg of
        OnUrlRequest request ->
            case request of
                Browser.External url ->
                    ( model, Browser.Navigation.load url )

                Browser.Internal url ->
                    if String.startsWith "/logAction" url.path then
                        String.replace "/logAction" "" url.path
                            |> (++) "Navigate to: "
                            |> logAction_ defaultLogContext

                    else
                        ( model
                        , Browser.Navigation.pushUrl model.navKey (Url.toString url)
                        )

        OnUrlChange url ->
            case ( extractPath hashBasedNavigation_ url, Array.get 0 model.chapters ) of
                ( "/", Just chapter_ ) ->
                    ( model
                    , Browser.Navigation.pushUrl model.navKey <| chapterUrl hashBasedNavigation_ chapter_
                    )

                ( "/", Nothing ) ->
                    ( { model | chapterActive = Nothing }, Cmd.none )

                _ ->
                    let
                        activeChapter =
                            parseActiveChapterFromUrl model.config model.chapters url
                    in
                    ( { model
                        | chapterActive = activeChapter
                        , isMenuOpen = False
                      }
                    , case activeChapter of
                        Just _ ->
                            Task.attempt
                                (\_ -> DoNothing)
                                (Browser.Dom.setViewportOf "elm-book-main" 0 0)

                        Nothing ->
                            Browser.Navigation.replaceUrl model.navKey
                                (if hashBasedNavigation_ then
                                    "#/"

                                 else
                                    "/"
                                )
                    )

        ToggleDarkMode ->
            ( { model | toggleDarkMode = not model.toggleDarkMode }
            , Cmd.none
            )

        UpdateState fn ->
            model.config.statefulOptions.state
                |> Maybe.map
                    (\state_ ->
                        let
                            config =
                                model.config

                            statefulOptions_ =
                                model.config.statefulOptions

                            statefulOptions__ =
                                { statefulOptions_ | state = Just (fn state_) }

                            config_ =
                                { config | statefulOptions = statefulOptions__ }
                        in
                        ( { model | config = config_ }
                        , Cmd.none
                        )
                    )
                |> Maybe.withDefault ( model, Cmd.none )

        UpdateStateWithCmd fn ->
            model.config.statefulOptions.state
                |> Maybe.map
                    (\state_ ->
                        let
                            config =
                                model.config

                            statefulOptions_ =
                                model.config.statefulOptions

                            ( state__, cmd ) =
                                fn state_

                            statefulOptions__ =
                                { statefulOptions_ | state = Just state__ }

                            config_ =
                                { config | statefulOptions = statefulOptions__ }
                        in
                        ( { model | config = config_ }
                        , cmd
                        )
                    )
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
                , chaptersSearched = model.chapters
              }
            , Cmd.none
            )

        Search value ->
            ( { model
                | search = value
                , chaptersSearched = searchChapters value model.chapters
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
                | chapterPreSelected = modBy (Array.length model.chaptersSearched) (model.chapterPreSelected + 1)
              }
            , Cmd.none
            )

        KeyArrowUp ->
            ( { model
                | chapterPreSelected = modBy (Array.length model.chaptersSearched) (model.chapterPreSelected - 1)
              }
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
            if model.isSearching then
                case Array.get model.chapterPreSelected model.chaptersSearched of
                    Just chapter_ ->
                        if String.startsWith "/" (chapterUrl hashBasedNavigation_ chapter_) then
                            ( model
                            , Browser.Navigation.pushUrl model.navKey (chapterUrl hashBasedNavigation_ chapter_)
                            )

                        else
                            ( model
                            , Browser.Navigation.load (chapterUrl hashBasedNavigation_ chapter_)
                            )

                    Nothing ->
                        ( model, Cmd.none )

            else
                ( model, Cmd.none )

        SetThemeBackgroundGradient startColor endColor ->
            ElmBook.ThemeOptions.backgroundGradient startColor endColor
                |> updateTheme model

        SetThemeBackground background ->
            ElmBook.ThemeOptions.background background
                |> updateTheme model

        SetThemeAccent accent ->
            ElmBook.ThemeOptions.accent accent
                |> updateTheme model

        SetThemeNavBackground navBackground ->
            ElmBook.ThemeOptions.navBackground navBackground
                |> updateTheme model

        SetThemeNavAccent navAccent ->
            ElmBook.ThemeOptions.navAccent navAccent
                |> updateTheme model

        SetThemeNavAccentHighlight navAccentHighlight ->
            ElmBook.ThemeOptions.navAccentHighlight navAccentHighlight
                |> updateTheme model

        DoNothing ->
            ( model, Cmd.none )


updateTheme : Model state html -> ElmBook.ThemeOptions.ThemeOption html -> ( Model state html, Cmd (Msg state) )
updateTheme model option =
    let
        config =
            model.config

        config_ =
            { config
                | themeOptions = option model.config.themeOptions
            }

        model_ =
            { model | config = config_ }
    in
    ( model_, Cmd.none )


withActionLogReset : Model state html -> ( Model state html, Cmd (Msg state) ) -> ( Model state html, Cmd (Msg state) )
withActionLogReset previousModel ( model, cmd ) =
    let
        chapterSlugActive : Maybe String
        chapterSlugActive =
            model.chapterActive
                |> Maybe.map (chapterUrl False)

        chapterSlugPrevious : Maybe String
        chapterSlugPrevious =
            previousModel.chapterActive
                |> Maybe.map (chapterUrl False)
    in
    if chapterSlugActive /= chapterSlugPrevious then
        ( { model | actionLog = [] }, cmd )

    else
        ( model, cmd )



-- View


view : Model state html -> Browser.Document (Msg state)
view model =
    { title =
        let
            mainTitle =
                ElmBook.Internal.ThemeOptions.subtitle model.config.themeOptions
                    |> Maybe.map (\s -> model.config.title ++ " | " ++ s)
                    |> Maybe.withDefault model.config.title
        in
        case model.chapterActive of
            Just (Chapter { title }) ->
                title ++ " - " ++ mainTitle

            Nothing ->
                mainTitle
    , body =
        [ ElmBook.UI.Styles.view
        , ElmBook.UI.Wrapper.view
            { theme = model.config.themeOptions
            , darkMode =
                case ( model.config.themeOptions.preferDarkMode, model.toggleDarkMode ) of
                    ( True, False ) ->
                        True

                    ( False, True ) ->
                        True

                    _ ->
                        False
            , isMenuOpen = model.isMenuOpen
            , globals =
                model.config.themeOptions.globals
                    |> Maybe.withDefault []
                    |> List.map model.config.toHtml
            , header =
                ElmBook.UI.Header.view
                    { toHtml = model.config.toHtml
                    , href = "/"
                    , theme = model.config.themeOptions
                    , title = model.config.title
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
                    hashBasedNavigation =
                        ElmBook.Internal.ThemeOptions.hashBasedNavigation model.config.themeOptions

                    visibleChapterUrls =
                        Array.toList model.chaptersSearched
                            |> List.map (chapterUrl hashBasedNavigation)
                in
                ElmBook.UI.Nav.view
                    { active = Maybe.map (chapterUrl hashBasedNavigation) model.chapterActive
                    , preSelected =
                        if model.isSearching then
                            Array.get model.chapterPreSelected model.chaptersSearched
                                |> Maybe.map (chapterUrl hashBasedNavigation)

                        else
                            Nothing
                    , itemGroups =
                        model.chapterGroups
                            |> List.map
                                (Tuple.mapSecond
                                    (List.map (\index -> Array.get index model.chapters)
                                        >> List.filterMap identity
                                        >> List.map (\((Chapter { title, internal }) as chapter) -> ( chapterUrl hashBasedNavigation chapter, title, internal ))
                                        >> List.filter (\( slug, _, _ ) -> List.member slug visibleChapterUrls)
                                    )
                                )
                    }
            , menuFooter = ElmBook.UI.Footer.view
            , mainHeader =
                model.chapterActive
                    |> Maybe.map
                        (\chapter ->
                            ElmBook.UI.ChapterHeader.view
                                { title = chapterBreadcrumb chapter
                                , onToggleDarkMode = ToggleDarkMode
                                }
                        )
            , main =
                model.chapterActive
                    |> Maybe.map
                        (\(Chapter activeChapter_) ->
                            ElmBook.UI.Chapter.view
                                { title = activeChapter_.title
                                , chapterOptions =
                                    activeChapter_.chapterOptions
                                        |> ElmBook.Internal.Chapter.toValidOptions
                                            model.config.chapterOptions
                                , componentOptions =
                                    activeChapter_.componentOptions
                                        |> ElmBook.Internal.ComponentOptions.toValidOptions
                                            model.config.componentOptions
                                , body = activeChapter_.body
                                , components =
                                    activeChapter_.componentList
                                        |> List.map
                                            (\component ->
                                                ( component.label
                                                , componentView
                                                    model.config.toHtml
                                                    model.config.statefulOptions.state
                                                    component.view
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


parseActiveChapterFromUrl : ElmBookConfig state html -> Array (ChapterCustom state html) -> Url.Url -> Maybe (ChapterCustom state html)
parseActiveChapterFromUrl config chapters url =
    let
        targetUrl =
            extractPath (hashBasedNavigation config.themeOptions) url
    in
    chapters
        |> Array.filter (\c -> chapterUrl False c == targetUrl)
        |> Array.get 0



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
