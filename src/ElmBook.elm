module ElmBook exposing
    ( book, withChapters, withChapterGroups, ElmBook
    , withGlobals
    , ElmBookCustom, ElmBookBuilder, ElmBookMsg, customBook
    , withComponentOptions, withTheme
    )

{-| A book that tells the story of the UI elements of your Elm application.


# Start with a chapter.

You can create one chapter for each one of your UI elements and split it in elements to showcase all of their possible variants.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withElements
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

Don't be limited by this pattern though. A chapter and its elements may be used however you want. For instance, if it's useful to have a catalog of possible colors or typographic styles in your documentation, why not dedicate a chapter to it?

@docs chapter, withElement, withElements, UIChapter


# Then, create your book.

Your ElmBook is a collection of chapters.

    book : ElmBook ()
    book =
        book "MyApp" ()
            |> withChapters
                [ colorsChapter
                , buttonsChapter
                , inputsChapter
                , chartsChapter
                ]

**Important**: Please note that you always need to use the `withChapters` functions as the final step of your setup.

This returns a standard `Browser.application`. You can choose to use it just as you would any Elm application – however, this package can also be added as a NPM dependency to be used as zero-config dev server to get things started.

If you want to use our zero-config dev server, just install `elm-ui-book` as a devDependency then run `npx elm-ui-book {MyBookModule}.elm` and you should see your brand new Book running on your browser.

@docs book, withChapters, withChapterGroups, ElmBook


# Customize the book's style.

You can configure your book with a few extra settings to make it more personalized. Want to change the theme color so it's more fitting to your brand? Sure. Want to use your app's logo as the header? Go crazy.

    book "MyApp" ()
        |> withColor "#007"
        |> withSubtitle "Design System"
        |> withChapters [ ... ]

@docs withLogo, withSubtitle, withHeader, withGlobals, withThemeBackground, withThemeBackgroundAlt, withThemeAccent, withThemeAccentAlt, themeBackground, themeBackgroundAlt, themeAccent, themeAccentAlt, withColor


# Integrate it with elm-css, elm-ui and others.

If you're using one of these two common ways of styling your Elm app, just import the proper definitions and you're good to go.

    import ElmBook exposing (withChapters)
    import ElmBook.ElmCSS exposing (ElmBook, book)

    main : ElmBook ()
    main =
        book "MyElmCSSApp" ()
            |> withChapters []

If you're using other packages that also work with a custom html, don't worry , defining a custom setup is pretty simple as well:

    module ElmBookCustom exposing (ElmBook, UIChapter, book)

    import ElmBook
    import MyCustomHtmlLibrary exposing (CustomHtml, toHtml)

    type alias ElmBookHtml state =
        CustomHtml (ElmBook.ElmBookMsg state)

    type alias UIChapter state =
        ElmBook.ChapterCustom state (ElmBookHtml state)

    type alias ElmBook state =
        ElmBook.ElmBookCustom state (ElmBookHtml state)

    book : String -> state -> ElmBook.ElmBookBuilder state (ElmBookHtml state)
    book title state =
        ElmBook.customBook
            { title = title
            , state = state
            , toHtml = toHtml
            }

Then you can `import ElmBookCustom exposing (ElmBook, UIChapter, book)` just as you would with `ElmBook.ElmCSS`.

@docs ChapterCustom, ElmBookCustom, ElmBookBuilder, ElmBookMsg, customBook


# Interact with it.

Log your action intents to showcase how your components would react to interactions.

@docs logAction, logActionWithString, logActionWithInt, logActionWithFloat, logActionMap


# Showcase stateful widgets

Sometimes it's useful to display a complex component so people can understand how it works on an isolated environment, not only see their possible static states. But how to accomplish this with Elm's static typing? Simply provide your own custom "state" that can be used and updated by your own elements.

    type alias MyState =
        { input : String, counter : Int }

    initialState : MyState
    initialState =
        { input = "", counter = 0 }

    main : ElmBook MyState
    main =
        book "MyStatefulApp" initialState
            |> withChapters
                [ inputChapter
                , counterChapter
                ]

    counterChapter : UIChapter { x | counter : Int }
    counterChapter =
        let
            updateCounter state =
                { state | counter = state.counter + 1 }
        in
        chapter "Counter"
            |> withStatefulElement
                (\state ->
                    button
                        [ onClick (updateState updateCounter) ]
                        [ text <| String.fromInt state.counter ]
                )

    inputChapter : UIChapter { x | input : String }
    inputChapter =
        let
            updateInput value state =
                { state | input = value }
        in
        chapter "Input"
            |> withStatefulElement
                (\state ->
                    input
                        [ value state.input
                        , onInput (updateState1 updateInput)
                        ]
                        []
                )

@docs withStatefulElement, withStatefulElements, updateState, updateState1

-}

import Array exposing (Array)
import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events exposing (onKeyDown, onKeyUp)
import Browser.Navigation as Nav
import ElmBook.Component
import ElmBook.Internal.Chapter exposing (ChapterCustom(..), chapterSlug, chapterTitle)
import ElmBook.Internal.Component exposing (ValidComponentOptions)
import ElmBook.Internal.Helpers exposing (toSlug)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.Theme exposing (Theme, defaultTheme)
import ElmBook.Theme
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
import List
import Task
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing ((</>), map, oneOf, parse, s, string)


{-| -}
type alias ElmBook state =
    ElmBookCustom state (Html (ElmBookMsg state))


{-| -}
type alias ElmBookCustom state html =
    Program () (Model state html) (Msg state)


{-| -}
type ElmBookBuilder state html
    = ElmBookBuilder (ElmBookConfig state html)


type alias ElmBookConfig state html =
    { urlPreffix : String
    , title : String
    , theme : Theme
    , componentOptions : ValidComponentOptions
    , state : state
    , toHtml : html -> Html (Msg state)
    , globals : Maybe (List html)
    }


{-| Kickoff the creation of an ElmBook application.
-}
book : String -> state -> ElmBookBuilder state (Html (Msg state))
book title state =
    customBook
        { title = title
        , state = state
        , toHtml = identity
        }


{-| -}
customBook :
    { title : String
    , state : state
    , toHtml : html -> Html (Msg state)
    }
    -> ElmBookBuilder state html
customBook config =
    ElmBookBuilder
        { urlPreffix = "chapter"
        , title = config.title
        , theme = defaultTheme
        , componentOptions = ElmBook.Internal.Component.defaultOptions
        , state = config.state
        , toHtml = config.toHtml
        , globals = Nothing
        }


{-| Customize your book's theme using any of the attributes available on `ElmBook.Theme`.
-}
withTheme : List ElmBook.Theme.Attribute -> ElmBookBuilder state html -> ElmBookBuilder state html
withTheme themeAttributes (ElmBookBuilder config) =
    ElmBookBuilder
        { config
            | theme =
                ElmBook.Internal.Theme.applyAttributes themeAttributes config.theme
        }


{-| Define the default options for your embedded components.
-}
withComponentOptions : List ElmBook.Component.Attribute -> ElmBookBuilder state html -> ElmBookBuilder state html
withComponentOptions componentAttributes (ElmBookBuilder config) =
    ElmBookBuilder
        { config
            | componentOptions =
                ElmBook.Internal.Component.applyAttributes componentAttributes ElmBook.Internal.Component.defaultOverrides
                    |> ElmBook.Internal.Component.toValidOptions config.componentOptions
        }


{-| Add global elements to your book. This can be helpful for things like CSS resets.

For instance, if you're using elm-tailwind-modules, this would be really helpful:

    import Css.Global exposing (global)
    import Tailwind.Utilities exposing (globalStyles)
    import ElmBook.ElmCSS exposing (book)

    book "MyApp"
        |> withGlobals [
            global globalStyles
        ]

-}
withGlobals : List html -> ElmBookBuilder state html -> ElmBookBuilder state html
withGlobals globals (ElmBookBuilder config) =
    ElmBookBuilder
        { config | globals = Just globals }


{-| List the chapters that should be displayed on your book.

**Should be used as the final step on your setup.**

-}
withChapters : List (ChapterCustom state html) -> ElmBookBuilder state html -> ElmBookCustom state html
withChapters chapters =
    withChapterGroups [ ( "", chapters ) ]


{-| List the chapters, divided by groups, that should be displayed on your book.

    book "MyApp"
        |> withChapterGroups
            [ ( "Guides"
              , [ gettingStartedChapter
                , sendingRequestsChapter
                ]
              )
            , ( "UI Widgets"
              , [ buttonsChapter
                , formsChapter
                , ...
                ]
              )
            ]

**Should be used as the final step on your setup.**

-}
withChapterGroups : List ( String, List (ChapterCustom state html) ) -> ElmBookBuilder state html -> ElmBookCustom state html
withChapterGroups chapterGroups_ (ElmBookBuilder config) =
    let
        chapterGroups =
            chapterGroups_
                |> List.map
                    (\( group, chapters ) ->
                        ( group
                        , List.map (chapterGroupSlug group) chapters
                        )
                    )
    in
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
                    ]
        }


chapterGroupSlug : String -> ChapterCustom state html -> ChapterCustom state html
chapterGroupSlug group (Chapter chapter_) =
    if group == "" then
        Chapter chapter_

    else
        Chapter { chapter_ | slug = toSlug group ++ "--" ++ chapter_.slug }



-- App


chapterWithSlug : String -> Array (ChapterCustom state html) -> Maybe (ChapterCustom state html)
chapterWithSlug targetSlug chapters =
    chapters
        |> Array.filter (\(Chapter { slug }) -> slug == targetSlug)
        |> Array.get 0


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


type alias Model state html =
    { navKey : Nav.Key
    , config : ElmBookConfig state html
    , chapterGroups : List ( String, List Int )
    , chapters : Array (ChapterCustom state html)
    , chaptersSearched : Array (ChapterCustom state html)
    , chapterActive : Maybe (ChapterCustom state html)
    , chapterPreSelected : Int
    , search : String
    , isSearching : Bool
    , isShiftPressed : Bool
    , isMetaPressed : Bool
    , actionLog : List ( String, String )
    , actionLogModal : Bool
    , isMenuOpen : Bool
    }


init :
    { chapterGroups : List ( String, List (ChapterCustom state html) )
    , config : ElmBookConfig state html
    }
    -> ()
    -> Url
    -> Nav.Key
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
                toIndexedGroup initialIndex =
                    Tuple.mapSecond (List.indexedMap (\i _ -> i + initialIndex))
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
            parseActiveChapterFromUrl props.config.urlPreffix chapters url
    in
    ( { navKey = navKey
      , config = props.config
      , chapterGroups = chapterGroups
      , chapters = chapters
      , chaptersSearched = chapters
      , chapterActive = activeChapter
      , chapterPreSelected = 0
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
                |> Maybe.map (Nav.replaceUrl navKey << urlFromChapter props.config.urlPreffix)
                |> Maybe.withDefault (Nav.replaceUrl navKey "/")
    )



-- Routing


type Route
    = Route String


urlFromChapter : String -> ChapterCustom state html -> String
urlFromChapter preffix (Chapter { slug }) =
    Url.Builder.absolute [ preffix, slug ] []


parseActiveChapterFromUrl : String -> Array (ChapterCustom state html) -> Url -> Maybe (ChapterCustom state html)
parseActiveChapterFromUrl preffix docsList url =
    parse (oneOf [ map Route (s preffix </> string) ]) url
        |> Maybe.andThen (\(Route slug) -> chapterWithSlug slug docsList)



-- Update


{-| -}
type alias ElmBookMsg state =
    Msg state


type alias Msg state =
    ElmBook.Internal.Msg.Msg state


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
    in
    case msg of
        OnUrlRequest request ->
            case request of
                External url ->
                    logAction_ defaultLogContext ("Navigate to: " ++ url)

                Internal url ->
                    if url.path == "/" || String.startsWith ("/" ++ model.config.urlPreffix ++ "/") url.path then
                        ( model, Nav.pushUrl model.navKey (Url.toString url) )

                    else
                        logAction_ defaultLogContext ("Navigate to: " ++ url.path)

        OnUrlChange url ->
            case ( url.path, Array.get 0 model.chapters ) of
                ( "/", Just chapter_ ) ->
                    ( model
                    , Nav.pushUrl model.navKey <| urlFromChapter model.config.urlPreffix chapter_
                    )

                ( "/", Nothing ) ->
                    ( { model | chapterActive = Nothing }, Cmd.none )

                _ ->
                    let
                        activeChapter =
                            parseActiveChapterFromUrl model.config.urlPreffix model.chapters url
                    in
                    ( { model
                        | chapterActive = activeChapter
                        , isMenuOpen = False
                      }
                    , case activeChapter of
                        Just _ ->
                            Cmd.none

                        Nothing ->
                            Nav.replaceUrl model.navKey "/"
                    )

        UpdateState fn ->
            let
                config =
                    model.config
            in
            ( { model | config = { config | state = fn config.state } }
            , Cmd.none
            )

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
                        ( model
                        , Nav.pushUrl model.navKey <| urlFromChapter model.config.urlPreffix chapter_
                        )

                    Nothing ->
                        ( model, Cmd.none )

            else
                ( model, Cmd.none )

        DoNothing ->
            ( model, Cmd.none )


withActionLogReset : Model state html -> ( Model state html, Cmd (Msg state) ) -> ( Model state html, Cmd (Msg state) )
withActionLogReset previousModel ( model, cmd ) =
    let
        chapterSlugActive : Maybe String
        chapterSlugActive =
            model.chapterActive
                |> Maybe.map chapterSlug

        chapterSlugPrevious : Maybe String
        chapterSlugPrevious =
            previousModel.chapterActive
                |> Maybe.map chapterSlug
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
                ElmBook.Internal.Theme.subtitle model.config.theme
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
            { theme = model.config.theme
            , isMenuOpen = model.isMenuOpen
            , globals =
                model.config.globals
                    |> Maybe.withDefault []
                    |> List.map model.config.toHtml
            , header =
                ElmBook.UI.Header.view
                    { href = "/"
                    , theme = model.config.theme
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
                    visibleChapterSlugs =
                        Array.toList model.chaptersSearched
                            |> List.map chapterSlug
                in
                ElmBook.UI.Nav.view
                    { preffix = model.config.urlPreffix
                    , active = Maybe.map chapterSlug model.chapterActive
                    , preSelected =
                        if model.isSearching then
                            Array.get model.chapterPreSelected model.chaptersSearched
                                |> Maybe.map chapterSlug

                        else
                            Nothing
                    , itemGroups =
                        model.chapterGroups
                            |> List.map
                                (Tuple.mapSecond
                                    (List.map (\index -> Array.get index model.chapters)
                                        >> List.filterMap identity
                                        >> List.map (\(Chapter { slug, title }) -> ( slug, title ))
                                        >> List.filter (\( slug, _ ) -> List.member slug visibleChapterSlugs)
                                    )
                                )
                    }
            , menuFooter = ElmBook.UI.Footer.view
            , mainHeader =
                model.chapterActive
                    |> Maybe.map (ElmBook.UI.ChapterHeader.view << chapterTitle)
            , main =
                model.chapterActive
                    |> Maybe.map
                        (\(Chapter activeChapter_) ->
                            ElmBook.UI.Chapter.view
                                { title = activeChapter_.title
                                , componentOptions =
                                    activeChapter_.componentOptions
                                        |> ElmBook.Internal.Component.toValidOptions
                                            model.config.componentOptions
                                , body = activeChapter_.body
                                , elements =
                                    activeChapter_.componentList
                                        |> List.map
                                            (\element ->
                                                ( element.label
                                                , element.view model.config.state
                                                    |> model.config.toHtml
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
