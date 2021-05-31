module ElmBook exposing
    ( chapter, withSection, withSections, withBackgroundColor, withDescription, withTwoColumns, UIChapter
    , book, withChapters, withChapterGroups, UIBook
    , withLogo, withSubtitle, withHeader, withGlobals, withThemeBackground, withThemeBackgroundAlt, withThemeAccent, withThemeAccentAlt, themeBackground, themeBackgroundAlt, themeAccent, themeAccentAlt, withColor
    , UIChapterCustom, UIBookCustom, UIBookBuilder, UIBookMsg, customBook
    , logAction, logActionWithString, logActionWithInt, logActionWithFloat, logActionMap
    , withStatefulSection, withStatefulSections, toStateful, updateState, updateState1
    )

{-| A book that tells the story of the UI elements of your Elm application.


# Start with a chapter.

You can create one chapter for each one of your UI elements and split it in sections to showcase all of their possible variants.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withSections
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

Don't be limited by this pattern though. A chapter and its sections may be used however you want. For instance, if it's useful to have a catalog of possible colors or typographic styles in your documentation, why not dedicate a chapter to it?

@docs chapter, withSection, withSections, withBackgroundColor, withDescription, withTwoColumns, UIChapter


# Then, create your book.

Your UIBook is a collection of chapters.

    book : UIBook ()
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

@docs book, withChapters, withChapterGroups, UIBook


# Customize the book's style.

You can configure your book with a few extra settings to make it more personalized. Want to change the theme color so it's more fitting to your brand? Sure. Want to use your app's logo as the header? Go crazy.

    book "MyApp" ()
        |> withColor "#007"
        |> withSubtitle "Design System"
        |> withChapters [ ... ]

@docs withLogo, withSubtitle, withHeader, withGlobals, withThemeBackground, withThemeBackgroundAlt, withThemeAccent, withThemeAccentAlt, themeBackground, themeBackgroundAlt, themeAccent, themeAccentAlt, withColor


# Integrate it with elm-css, elm-ui and others.

If you're using one of these two common ways of styling your Elm app, just import the proper definitions and you're good to go.

    import UIBook exposing (withChapters)
    import UIBook.ElmCSS exposing (UIBook, book)

    main : UIBook ()
    main =
        book "MyElmCSSApp" ()
            |> withChapters []

If you're using other packages that also work with a custom html, don't worry , defining a custom setup is pretty simple as well:

    module UIBookCustom exposing (UIBook, UIChapter, book)

    import MyCustomHtmlLibrary exposing (CustomHtml, toHtml)
    import UIBook

    type alias UIBookHtml state =
        CustomHtml (UIBook.UIBookMsg state)

    type alias UIChapter state =
        UIBook.UIChapterCustom state (UIBookHtml state)

    type alias UIBook state =
        UIBook.UIBookCustom state (UIBookHtml state)

    book : String -> state -> UIBook.UIBookBuilder state (UIBookHtml state)
    book title state =
        UIBook.customBook
            { title = title
            , state = state
            , toHtml = toHtml
            }

Then you can `import UIBookCustom exposing (UIBook, UIChapter, book)` just as you would with `UIBook.ElmCSS`.

@docs UIChapterCustom, UIBookCustom, UIBookBuilder, UIBookMsg, customBook


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

    main : UIBook MyState
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
            |> withStatefulSection
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
            |> withStatefulSection
                (\state ->
                    input
                        [ value state.input
                        , onInput (updateState1 updateInput)
                        ]
                        []
                )

@docs withStatefulSection, withStatefulSections, toStateful, updateState, updateState1

-}

import Array exposing (Array)
import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events exposing (onKeyDown, onKeyUp)
import Browser.Navigation as Nav
import Html exposing (Html)
import Html.Styled exposing (fromUnstyled, text, toUnstyled)
import Json.Decode as Decode
import List
import Task
import UIBook.Msg exposing (..)
import UIBook.UI.ActionLog
import UIBook.UI.Chapter exposing (ChapterLayout(..))
import UIBook.UI.ChapterHeader
import UIBook.UI.Footer
import UIBook.UI.Header
import UIBook.UI.Helpers
import UIBook.UI.Nav
import UIBook.UI.Search
import UIBook.UI.Wrapper
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing ((</>), map, oneOf, parse, s, string)


{-| -}
type alias UIBook state =
    UIBookCustom state (Html (UIBookMsg state))


{-| -}
type alias UIBookCustom state html =
    Program () (Model state html) (Msg state)


{-| -}
type UIBookBuilder state html
    = UIBookBuilder (UIBookConfig state html)


type alias UIBookConfig state html =
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


{-| Kickoff the creation of an UIBook application.
-}
book : String -> state -> UIBookBuilder state (Html (Msg state))
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
    -> UIBookBuilder state html
customBook config =
    UIBookBuilder
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
withThemeBackground : String -> UIBookBuilder state html -> UIBookBuilder state html
withThemeBackground themeBackground_ (UIBookBuilder config) =
    UIBookBuilder
        { config | themeBackground = themeBackground_ }


{-| Customize your book's background alt color. Any valid CSS `background` value can be used.
-}
withThemeBackgroundAlt : String -> UIBookBuilder state html -> UIBookBuilder state html
withThemeBackgroundAlt themeBackgroundAlt_ (UIBookBuilder config) =
    UIBookBuilder
        { config | themeBackgroundAlt = themeBackgroundAlt_ }


{-| Customize your book's accent color. Any valid CSS `color` value can be used.
-}
withThemeAccent : String -> UIBookBuilder state html -> UIBookBuilder state html
withThemeAccent themeAccent_ (UIBookBuilder config) =
    UIBookBuilder
        { config | themeAccent = themeAccent_ }


{-| Customize your book's accent alt color. Any valid CSS `color` value can be used.
-}
withThemeAccentAlt : String -> UIBookBuilder state html -> UIBookBuilder state html
withThemeAccentAlt themeAccentAlt_ (UIBookBuilder config) =
    UIBookBuilder
        { config | themeAccentAlt = themeAccentAlt_ }


{-| [DEPRECATED] This has the same effect as `withThemeBackground`.
-}
withColor : String -> UIBookBuilder state html -> UIBookBuilder state html
withColor =
    withThemeBackground


{-| Use your theme background color on other parts of your book.

    chapter : UIChapter x
    chapter
        |> withSection
            (p
                [ style "background" themeBackground ]
                [ text "Hello." ]
            )

-}
themeBackground : String
themeBackground =
    UIBook.UI.Helpers.themeBackground


{-| Use your theme background alt color on other parts of your book.
-}
themeBackgroundAlt : String
themeBackgroundAlt =
    UIBook.UI.Helpers.themeBackgroundAlt


{-| Use your theme accent color on other parts of your book.

    chapter : UIChapter x
    chapter
        |> withSection
            (p
                [ style "color" themeAccent ]
                [ text "Hello." ]
            )

-}
themeAccent : String
themeAccent =
    UIBook.UI.Helpers.themeAccent


{-| Use your theme accent alt color on other parts of your book.
-}
themeAccentAlt : String
themeAccentAlt =
    UIBook.UI.Helpers.themeAccentAlt


{-| Customize the header logo to match your brand.
-}
withLogo : html -> UIBookBuilder state html -> UIBookBuilder state html
withLogo logo (UIBookBuilder config) =
    UIBookBuilder
        { config | logo = Just logo }


{-| Replace the default "UI Docs" subtitle with a custom one.
-}
withSubtitle : String -> UIBookBuilder state html -> UIBookBuilder state html
withSubtitle subtitle (UIBookBuilder config) =
    UIBookBuilder
        { config | subtitle = subtitle }


{-| Replace the entire header with a custom one.

    book "MyApp"
        |> withHeader (h1 [ style "color" "crimson" ] [ text "My App" ])
        |> withChapters []

Note that your header must use the same type of html as your chapters. So if you're using `elm-ui`, then your header would need to be typed as `Element msg`.

-}
withHeader : html -> UIBookBuilder state html -> UIBookBuilder state html
withHeader customHeader (UIBookBuilder config) =
    UIBookBuilder
        { config | customHeader = Just customHeader }


{-| Add global elements to your book. This can be helpful for things like CSS resets.

For instance, if you're using elm-tailwind-modules, this would be really helpful:

    import Css.Global exposing (global)
    import Tailwind.Utilities exposing (globalStyles)
    import UIBook.ElmCSS exposing (book)

    book "MyApp"
        |> withGlobals [
            global globalStyles
        ]

-}
withGlobals : List html -> UIBookBuilder state html -> UIBookBuilder state html
withGlobals globals (UIBookBuilder config) =
    UIBookBuilder
        { config | globals = Just globals }


{-| List the chapters that should be displayed on your book.

**Should be used as the final step on your setup.**

-}
withChapters : List (UIChapterCustom state html) -> UIBookBuilder state html -> UIBookCustom state html
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
withChapterGroups : List ( String, List (UIChapterCustom state html) ) -> UIBookBuilder state html -> UIBookCustom state html
withChapterGroups chapterGroups_ (UIBookBuilder config) =
    let
        chapterGroups =
            chapterGroups_
                |> List.map
                    (\( group, chapters ) ->
                        ( group
                        , List.map (addGroupToSlug group) chapters
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
    UIChapterCustom state (Html (UIBookMsg state))


{-| -}
type UIChapterCustom state html
    = UIChapter (UIChapterConfig state html)


type UIChapterBuilder state html
    = UIChapterBuilder (UIChapterConfig state html)


type alias UIChapterConfig state html =
    { title : String
    , slug : String
    , sections : List (UIChapterSection state html)
    , layout : ChapterLayout
    , description : Maybe String
    , backgroundColor : Maybe String
    }


type alias UIChapterSection state html =
    { label : String
    , view : state -> html
    }


{-| Use this to make your life easier when mixing stateful and static sections.

    chapter "ComplexWidget"
        |> withStatefulSections
            [ ( "Interactive", (\state -> ... ) )
            , toStateful ( "State1", widgetInState1 )
            , toStateful ( "State2", widgetInState1 )
            ]

-}
toStateful : ( String, html ) -> UIChapterSection state html
toStateful ( label, html ) =
    { label = label
    , view = \_ -> html
    }


fromTuple : ( String, state -> html ) -> UIChapterSection state html
fromTuple ( label, view_ ) =
    { label = label, view = view_ }


{-| Creates a chapter with some title.
-}
chapter : String -> UIChapterBuilder state html
chapter title =
    UIChapterBuilder
        { title = title
        , slug = toSlug title
        , sections = []
        , layout = SingleColumn
        , description = Nothing
        , backgroundColor = Nothing
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


addGroupToSlug : String -> UIChapterCustom state html -> UIChapterCustom state html
addGroupToSlug group (UIChapter chapter_) =
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


{-| Used for customizing the background color of a chapter's sections.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withBackgroundColor "#F0F"
            |> withSections
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

-}
withBackgroundColor : String -> UIChapterBuilder state html -> UIChapterBuilder state html
withBackgroundColor backgroundColor_ (UIChapterBuilder config) =
    UIChapterBuilder
        { config | backgroundColor = Just backgroundColor_ }


{-| Used for adding a markdown description to your chapter.
-}
withDescription : String -> UIChapterBuilder state html -> UIChapterBuilder state html
withDescription description (UIChapterBuilder config) =
    UIChapterBuilder
        { config | description = Just description }


{-| Used for chapters with a single section.

    inputChapter : UIChapter x
    inputChapter =
        chapter "Input"
            |> withSection (input [] [])

-}
withSection : html -> UIChapterBuilder state html -> UIChapterCustom state html
withSection html (UIChapterBuilder builder) =
    UIChapter
        { builder | sections = [ toStateful ( "", html ) ] }


{-| Used for chapters with multiple sections.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withSections
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

-}
withSections : List ( String, html ) -> UIChapterBuilder state html -> UIChapterCustom state html
withSections sections (UIChapterBuilder builder) =
    UIChapter
        { builder | sections = List.map toStateful sections }


{-| Used for chapters with a single stateful section.
-}
withStatefulSection : (state -> html) -> UIChapterBuilder state html -> UIChapterCustom state html
withStatefulSection view_ (UIChapterBuilder builder) =
    UIChapter
        { builder | sections = [ { label = "", view = view_ } ] }


{-| Used for chapters with multiple stateful sections.

This is often used for displaying one interactive section and then multiple sections showcasing static states. Check `toStateful` if you are instered in this setup.

-}
withStatefulSections : List ( String, state -> html ) -> UIChapterBuilder state html -> UIChapterCustom state html
withStatefulSections sections (UIChapterBuilder builder) =
    UIChapter
        { builder | sections = List.map fromTuple sections }



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
    , config : UIBookConfig state html
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
    , config : UIBookConfig state html
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
type alias UIBookMsg state =
    Msg state


type alias Msg state =
    UIBook.Msg.Msg state


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
                ( model, Task.attempt (\_ -> DoNothing) (Browser.Dom.focus "ui-book-search") )

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
            |> withStatefulSection
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
            |> withStatefulSection
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
        [ UIBook.UI.Wrapper.view
            { themeBackground = model.config.themeBackground
            , themeBackgroundAlt = model.config.themeBackgroundAlt
            , themeAccent = model.config.themeAccent
            , themeAccentAlt = model.config.themeAccentAlt
            , isMenuOpen = model.isMenuOpen
            , globals =
                model.config.globals
                    |> Maybe.withDefault []
                    |> List.map
                        (model.config.toHtml
                            >> fromUnstyled
                        )
            , header =
                UIBook.UI.Header.view
                    { href = "/"
                    , logo =
                        model.config.logo
                            |> Maybe.map
                                (model.config.toHtml
                                    >> Html.map (\_ -> DoNothing)
                                    >> fromUnstyled
                                )
                    , title = model.config.title
                    , subtitle = model.config.subtitle
                    , custom =
                        model.config.customHeader
                            |> Maybe.map
                                (model.config.toHtml
                                    >> Html.map (\_ -> DoNothing)
                                    >> fromUnstyled
                                )
                    , isMenuOpen = model.isMenuOpen
                    , onClickMenuButton = ToggleMenu
                    }
            , menuHeader =
                UIBook.UI.Search.view
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
                UIBook.UI.Nav.view
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
            , menuFooter = UIBook.UI.Footer.view
            , mainHeader =
                model.chapterActive
                    |> Maybe.map (UIBook.UI.ChapterHeader.view << chapterTitle)
            , main =
                model.chapterActive
                    |> Maybe.map
                        (\(UIChapter activeChapter_) ->
                            UIBook.UI.Chapter.view
                                { title = activeChapter_.title
                                , layout = activeChapter_.layout
                                , description = activeChapter_.description
                                , backgroundColor = activeChapter_.backgroundColor
                                , sections =
                                    activeChapter_.sections
                                        |> List.map
                                            (\section ->
                                                ( section.label
                                                , section.view model.config.state
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
                            UIBook.UI.ActionLog.preview
                                { lastActionIndex = List.length model.actionLog
                                , lastAction = lastAction
                                , onClick = ActionLogShow
                                }
                        )
                    |> Maybe.withDefault UIBook.UI.ActionLog.previewEmpty
            , modal =
                if model.actionLogModal then
                    Just <|
                        UIBook.UI.ActionLog.list model.actionLog

                else
                    Nothing
            , onCloseModal = ActionLogHide
            }
            |> toUnstyled
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
