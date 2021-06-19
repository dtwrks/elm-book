module ElmBook exposing
    ( chapter, withElement, withElements, withBackgroundColor, withTwoColumns, UIChapter
    , book, withChapters, withChapterGroups, ElmBook
    , withLogo, withSubtitle, withHeader, withGlobals, withThemeBackground, withThemeBackgroundAlt, withThemeAccent, withThemeAccentAlt, themeBackground, themeBackgroundAlt, themeAccent, themeAccentAlt, withColor
    , UIChapterCustom, ElmBookCustom, ElmBookBuilder, ElmBookMsg, customBook
    , logAction, logActionWithString, logActionWithInt, logActionWithFloat, logActionMap
    , withStatefulElement, withStatefulElements, updateState, updateState1
    , render, renderElements, renderElementsWithBackground, renderWithElements
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

@docs chapter, withElement, withElements, withBackgroundColor, withTwoColumns, UIChapter


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
        ElmBook.UIChapterCustom state (ElmBookHtml state)

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

@docs UIChapterCustom, ElmBookCustom, ElmBookBuilder, ElmBookMsg, customBook


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
import ElmBook.Msg exposing (..)
import ElmBook.UI.ActionLog
import ElmBook.UI.Chapter exposing (ChapterLayout(..))
import ElmBook.UI.ChapterHeader
import ElmBook.UI.Footer
import ElmBook.UI.Header
import ElmBook.UI.Helpers
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
    , logo : Maybe html
    , title : String
    , subtitle : String
    , customHeader : Maybe html
    , themeBackground : String
    , themeBackgroundAlt : String
    , themeAccent : String
    , themeAccentAlt : String
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
        , logo = Nothing
        , title = config.title
        , subtitle = "UI Book"
        , customHeader = Nothing
        , themeBackground = "linear-gradient(150deg, rgba(0,135,207,1) 0%, rgba(86,207,255,1) 100%)"
        , themeBackgroundAlt = "#fff"
        , themeAccent = "#fff"
        , themeAccentAlt = "#fff"
        , state = config.state
        , toHtml = config.toHtml
        , globals = Nothing
        }


{-| Customize your book's background color. Any valid CSS `background` value can be used.
-}
withThemeBackground : String -> ElmBookBuilder state html -> ElmBookBuilder state html
withThemeBackground themeBackground_ (ElmBookBuilder config) =
    ElmBookBuilder
        { config | themeBackground = themeBackground_ }


{-| Customize your book's background alt color. Any valid CSS `background` value can be used.
-}
withThemeBackgroundAlt : String -> ElmBookBuilder state html -> ElmBookBuilder state html
withThemeBackgroundAlt themeBackgroundAlt_ (ElmBookBuilder config) =
    ElmBookBuilder
        { config | themeBackgroundAlt = themeBackgroundAlt_ }


{-| Customize your book's accent color. Any valid CSS `color` value can be used.
-}
withThemeAccent : String -> ElmBookBuilder state html -> ElmBookBuilder state html
withThemeAccent themeAccent_ (ElmBookBuilder config) =
    ElmBookBuilder
        { config | themeAccent = themeAccent_ }


{-| Customize your book's accent alt color. Any valid CSS `color` value can be used.
-}
withThemeAccentAlt : String -> ElmBookBuilder state html -> ElmBookBuilder state html
withThemeAccentAlt themeAccentAlt_ (ElmBookBuilder config) =
    ElmBookBuilder
        { config | themeAccentAlt = themeAccentAlt_ }


{-| [DEPRECATED] This has the same effect as `withThemeBackground`.
-}
withColor : String -> ElmBookBuilder state html -> ElmBookBuilder state html
withColor =
    withThemeBackground


{-| Use your theme background color on other parts of your book.

    chapter : UIChapter x
    chapter
        |> withElement
            (p
                [ style "background" themeBackground ]
                [ text "Hello." ]
            )

-}
themeBackground : String
themeBackground =
    ElmBook.UI.Helpers.themeBackground


{-| Use your theme background alt color on other parts of your book.
-}
themeBackgroundAlt : String
themeBackgroundAlt =
    ElmBook.UI.Helpers.themeBackgroundAlt


{-| Use your theme accent color on other parts of your book.

    chapter : UIChapter x
    chapter
        |> withElement
            (p
                [ style "color" themeAccent ]
                [ text "Hello." ]
            )

-}
themeAccent : String
themeAccent =
    ElmBook.UI.Helpers.themeAccent


{-| Use your theme accent alt color on other parts of your book.
-}
themeAccentAlt : String
themeAccentAlt =
    ElmBook.UI.Helpers.themeAccentAlt


{-| Customize the header logo to match your brand.
-}
withLogo : html -> ElmBookBuilder state html -> ElmBookBuilder state html
withLogo logo (ElmBookBuilder config) =
    ElmBookBuilder
        { config | logo = Just logo }


{-| Replace the default "UI Docs" subtitle with a custom one.
-}
withSubtitle : String -> ElmBookBuilder state html -> ElmBookBuilder state html
withSubtitle subtitle (ElmBookBuilder config) =
    ElmBookBuilder
        { config | subtitle = subtitle }


{-| Replace the entire header with a custom one.

    book "MyApp"
        |> withHeader (h1 [ style "color" "crimson" ] [ text "My App" ])
        |> withChapters []

Note that your header must use the same type of html as your chapters. So if you're using `elm-ui`, then your header would need to be typed as `Element msg`.

-}
withHeader : html -> ElmBookBuilder state html -> ElmBookBuilder state html
withHeader customHeader (ElmBookBuilder config) =
    ElmBookBuilder
        { config | customHeader = Just customHeader }


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
withChapters : List (UIChapterCustom state html) -> ElmBookBuilder state html -> ElmBookCustom state html
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
withChapterGroups : List ( String, List (UIChapterCustom state html) ) -> ElmBookBuilder state html -> ElmBookCustom state html
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


{-| -}
type alias UIChapter state =
    UIChapterCustom state (Html (ElmBookMsg state))


{-| -}
type UIChapterCustom state html
    = UIChapter (UIChapterConfig state html)


type UIChapterBuilder state html
    = UIChapterBuilder (UIChapterConfig state html)


type alias UIChapterConfig state html =
    { title : String
    , slug : String
    , elements : List (UIChapterelement state html)
    , layout : ChapterLayout
    , backgroundColor : Maybe String
    , body : String
    }


type alias UIChapterelement state html =
    { label : String
    , view : state -> html
    }


{-| Use this to make your life easier when mixing stateful and static elements.

    chapter "ComplexWidget"
        |> withStatefulElements
            [ ( "Interactive", (\state -> ... ) )
            ]

-}
toStateful : ( String, html ) -> UIChapterelement state html
toStateful ( label, html ) =
    { label = label
    , view = \_ -> html
    }


fromTuple : ( String, state -> html ) -> UIChapterelement state html
fromTuple ( label, view_ ) =
    { label = label, view = view_ }


{-| Creates a chapter with some title.
-}
chapter : String -> UIChapterBuilder state html
chapter title =
    UIChapterBuilder
        { title = title
        , slug = toSlug title
        , elements = []
        , layout = SingleColumn
        , backgroundColor = Nothing
        , body = ""
        }


toSlug : String -> String
toSlug =
    String.toLower >> String.replace " " "-"


chapterTitle : UIChapterCustom state html -> String
chapterTitle (UIChapter { title }) =
    title


chapterSlug : UIChapterCustom state html -> String
chapterSlug (UIChapter { slug }) =
    slug


chapterGroupSlug : String -> UIChapterCustom state html -> UIChapterCustom state html
chapterGroupSlug group (UIChapter chapter_) =
    if group == "" then
        UIChapter chapter_

    else
        UIChapter { chapter_ | slug = toSlug group ++ "--" ++ chapter_.slug }


{-| Used to customize your chapter with a two column layout.
-}
withTwoColumns : UIChapterBuilder state html -> UIChapterBuilder state html
withTwoColumns (UIChapterBuilder config) =
    UIChapterBuilder
        { config | layout = TwoColumns }


{-| Used for customizing the background color of a chapter's elements.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withBackgroundColor "#F0F"
            |> withElements
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

-}
withBackgroundColor : String -> UIChapterBuilder state html -> UIChapterBuilder state html
withBackgroundColor backgroundColor_ (UIChapterBuilder config) =
    UIChapterBuilder
        { config | backgroundColor = Just backgroundColor_ }


{-| Used for chapters with a single element.

    inputChapter : UIChapter x
    inputChapter =
        chapter "Input"
            |> withElement (input [] [])

-}
withElement : html -> UIChapterBuilder state html -> UIChapterBuilder state html
withElement html (UIChapterBuilder builder) =
    UIChapterBuilder
        { builder | elements = [ toStateful ( "", html ) ] }


{-| Used for chapters with multiple elements.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withElements
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

-}
withElements : List ( String, html ) -> UIChapterBuilder state html -> UIChapterBuilder state html
withElements elements (UIChapterBuilder builder) =
    UIChapterBuilder
        { builder | elements = List.map toStateful elements }


{-| Used for chapters with a single stateful element.
-}
withStatefulElement : (state -> html) -> UIChapterBuilder state html -> UIChapterBuilder state html
withStatefulElement view_ (UIChapterBuilder builder) =
    UIChapterBuilder
        { builder | elements = [ { label = "", view = view_ } ] }


{-| Used for chapters with multiple stateful elements.
-}
withStatefulElements : List ( String, state -> html ) -> UIChapterBuilder state html -> UIChapterBuilder state html
withStatefulElements elements (UIChapterBuilder builder) =
    UIChapterBuilder
        { builder | elements = List.map fromTuple elements }


{-| Used when you just want to render the list of elements with no additional information.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withElements
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]
            |> renderElements

-}
renderElements : UIChapterBuilder state html -> UIChapterCustom state html
renderElements (UIChapterBuilder builder) =
    UIChapter
        { builder | body = "<all-elements />" }


{-| Same as `renderElements` but you must also provide a background color for all of the elements cards.

    |> renderElementsCustom [
        elementsBackground "...",
        elementsFullWidth
    ]

-}
renderElementsWithBackground : String -> UIChapterBuilder state html -> UIChapterCustom state html
renderElementsWithBackground background (UIChapterBuilder builder) =
    UIChapter
        { builder | body = "<all-elements with-background=\"" ++ background ++ "\" />" }


{-| Used when you want to create a rich chapter with markdown and embedded elements.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withElements
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]
            |> render """
        # Buttons

        A button can be both active

        <element with-label="Default" />

        or inactive:

        <element with-label="Disabled" />

    """

-}
render : String -> UIChapterBuilder state html -> UIChapterCustom state html
render body (UIChapterBuilder builder) =
    UIChapter
        { builder | body = body }


{-| Used on chapters where all of the text content sits on top and all elements at the bottom.
-}
renderWithElements : String -> UIChapterBuilder state html -> UIChapterCustom state html
renderWithElements body (UIChapterBuilder builder) =
    UIChapter
        { builder | body = body ++ "\n<all-elements />" }



-- App


chapterWithSlug : String -> Array (UIChapterCustom state html) -> Maybe (UIChapterCustom state html)
chapterWithSlug targetSlug chapters =
    chapters
        |> Array.filter (\(UIChapter { slug }) -> slug == targetSlug)
        |> Array.get 0


searchChapters : String -> Array (UIChapterCustom state html) -> Array (UIChapterCustom state html)
searchChapters search chapters =
    case search of
        "" ->
            chapters

        _ ->
            let
                searchLowerCase =
                    String.toLower search

                titleMatchesSearch (UIChapter { title }) =
                    String.contains searchLowerCase (String.toLower title)
            in
            Array.filter titleMatchesSearch chapters


type alias Model state html =
    { navKey : Nav.Key
    , config : ElmBookConfig state html
    , chapterGroups : List ( String, List Int )
    , chapters : Array (UIChapterCustom state html)
    , chaptersSearched : Array (UIChapterCustom state html)
    , chapterActive : Maybe (UIChapterCustom state html)
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
    { chapterGroups : List ( String, List (UIChapterCustom state html) )
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


urlFromChapter : String -> UIChapterCustom state html -> String
urlFromChapter preffix (UIChapter { slug }) =
    Url.Builder.absolute [ preffix, slug ] []


parseActiveChapterFromUrl : String -> Array (UIChapterCustom state html) -> Url -> Maybe (UIChapterCustom state html)
parseActiveChapterFromUrl preffix docsList url =
    parse (oneOf [ map Route (s preffix </> string) ]) url
        |> Maybe.andThen (\(Route slug) -> chapterWithSlug slug docsList)



-- Update


{-| -}
type alias ElmBookMsg state =
    Msg state


type alias Msg state =
    ElmBook.Msg.Msg state


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



-- Public Actions


{-| Logs an action that takes no inputs.

    -- Will log "Clicked!" after pressing the button
    button [ onClick <| logAction "Clicked!" ] []

-}
logAction : String -> Msg state
logAction action =
    LogAction "" action


{-| Logs an action that takes one `String` input.

    -- Will log "Input: x" after pressing the "x" key
    input [ onInput <| logActionWithString "Input: " ] []

-}
logActionWithString : String -> String -> Msg state
logActionWithString action value =
    LogAction "" (action ++ ": " ++ value)


{-| Logs an action that takes one `Int` input.
-}
logActionWithInt : String -> String -> Msg state
logActionWithInt action value =
    LogAction "" (action ++ ": " ++ value)


{-| Logs an action that takes one `Float` input.
-}
logActionWithFloat : String -> String -> Msg state
logActionWithFloat action value =
    LogAction "" (action ++ ": " ++ value)


{-| Logs an action that takes one generic input that can be transformed into a String.

    eventToString : Event -> String
    eventToString event =
        case event of
            Start ->
                "Start"

            Finish ->
                "Finish"

    myCustomElement {
        onEvent =
            logActionMap "My Custom Element: " eventToString
    }

-}
logActionMap : String -> (value -> String) -> value -> Msg state
logActionMap action toString value =
    LogAction "" (action ++ ": " ++ toString value)



-- Updating State


{-| Updates the state of your stateful book.

    counterChapter : UIChapter { x | counter : Int }
    counterChapter =
        let
            update state =
                { state | counter = state.counter + 1 }
        in
        chapter "Counter"
            |> withStatefulElement
                (\state ->
                    button
                        [ onClick (updateState update) ]
                        [ text <| String.fromInt state.counter ]
                )

-}
updateState : (state -> state) -> Msg state
updateState =
    UpdateState


{-| Used when updating the state based on an argument.

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

-}
updateState1 : (a -> state -> state) -> a -> Msg state
updateState1 fn a =
    UpdateState (fn a)



-- View


view : Model state html -> Browser.Document (Msg state)
view model =
    { title =
        let
            mainTitle =
                model.config.title ++ " | " ++ model.config.subtitle
        in
        case model.chapterActive of
            Just (UIChapter { title }) ->
                title ++ " - " ++ mainTitle

            Nothing ->
                mainTitle
    , body =
        [ ElmBook.UI.Styles.view
        , ElmBook.UI.Wrapper.view
            { themeBackground = model.config.themeBackground
            , themeBackgroundAlt = model.config.themeBackgroundAlt
            , themeAccent = model.config.themeAccent
            , themeAccentAlt = model.config.themeAccentAlt
            , isMenuOpen = model.isMenuOpen
            , globals =
                model.config.globals
                    |> Maybe.withDefault []
                    |> List.map model.config.toHtml
            , header =
                ElmBook.UI.Header.view
                    { href = "/"
                    , logo =
                        model.config.logo
                            |> Maybe.map
                                (model.config.toHtml
                                    >> Html.map (\_ -> DoNothing)
                                )
                    , title = model.config.title
                    , subtitle = model.config.subtitle
                    , custom =
                        model.config.customHeader
                            |> Maybe.map
                                (model.config.toHtml
                                    >> Html.map (\_ -> DoNothing)
                                )
                    , isMenuOpen = model.isMenuOpen
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
                                        >> List.map (\(UIChapter { slug, title }) -> ( slug, title ))
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
                        (\(UIChapter activeChapter_) ->
                            ElmBook.UI.Chapter.view
                                { title = activeChapter_.title
                                , layout = activeChapter_.layout
                                , body = activeChapter_.body
                                , elements =
                                    activeChapter_.elements
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
