module ElmBook exposing
    ( book, withChapters, withChapterGroups, ElmBook
    , withApplicationOptions, withComponentOptions, withThemeOptions
    )

{-| A book that tells the story of the UI components of your Elm application.


# Start with a chapter.

You can create one chapter for each one of your UI components and split it in components to showcase all of their possible variants.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withComponents
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

Don't be limited by this pattern though. A chapter and its components may be used however you want. For instance, if it's useful to have a catalog of possible colors or typographic styles in your documentation, why not dedicate a chapter to it?

@docs chapter, withComponent, withComponents, UIChapter


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

@docs logAction, logActionWithString, logActionWithInt, logActionWithFloat, logActionWith


# Showcase stateful widgets

Sometimes it's useful to display a complex component so people can understand how it works on an isolated environment, not only see their possible static states. But how to accomplish this with Elm's static typing? Simply provide your own custom "state" that can be used and updated by your own components.

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
            |> withStatefulComponent
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
            |> withStatefulComponent
                (\state ->
                    input
                        [ value state.input
                        , onInput (updateStateWith updateInput)
                        ]
                        []
                )

@docs withStatefulComponent, withStatefulComponents, updateState, updateStateWith

-}

import Browser exposing (UrlRequest(..))
import ElmBook.Application
import ElmBook.Component
import ElmBook.Custom
import ElmBook.Internal.Application exposing (Application)
import ElmBook.Internal.Book exposing (ElmBookBuilder(..))
import ElmBook.Internal.Chapter exposing (ChapterCustom(..), chapterWithGroup)
import ElmBook.Internal.Component
import ElmBook.Internal.Helpers exposing (applyAttributes)
import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Theme
import Html exposing (Html)


{-| -}
type alias ElmBook state =
    Application state (Html (Msg state))


{-| Kickoff the creation of an ElmBook application.
-}
book : String -> ElmBookBuilder state (Html (Msg state))
book =
    ElmBook.Custom.customBook identity


{-| -}
withApplicationOptions : List (ElmBook.Application.Attribute state html) -> ElmBookBuilder state html -> ElmBookBuilder state html
withApplicationOptions applicationAttributes (ElmBookBuilder config) =
    ElmBookBuilder
        { config | application = applyAttributes applicationAttributes config.application }


{-| Customize your book's theme using any of the attributes available on `ElmBook.Theme`.
-}
withThemeOptions : List ElmBook.Theme.Attribute -> ElmBookBuilder state html -> ElmBookBuilder state html
withThemeOptions themeAttributes (ElmBookBuilder config) =
    ElmBookBuilder
        { config | theme = applyAttributes themeAttributes config.theme }


{-| Define the default options for your embedded components.
-}
withComponentOptions : List ElmBook.Component.Attribute -> ElmBookBuilder state html -> ElmBookBuilder state html
withComponentOptions componentAttributes (ElmBookBuilder config) =
    ElmBookBuilder
        { config
            | componentOptions =
                applyAttributes componentAttributes ElmBook.Internal.Component.defaultOverrides
                    |> ElmBook.Internal.Component.toValidOptions config.componentOptions
        }


{-| List the chapters that should be displayed on your book.

**Should be used as the final step on your setup.**

-}
withChapters : List (ChapterCustom state html) -> ElmBookBuilder state html -> Application state html
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
withChapterGroups :
    List ( String, List (ChapterCustom state html) )
    -> ElmBookBuilder state html
    -> Application state html
withChapterGroups chapterGroups_ =
    ElmBook.Internal.Application.application
        (chapterGroups_
            |> List.map
                (\( group, chapters ) ->
                    ( group
                    , List.map (chapterWithGroup group) chapters
                    )
                )
        )
