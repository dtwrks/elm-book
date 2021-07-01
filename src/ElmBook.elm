module ElmBook exposing
    ( book, withChapters, withChapterGroups
    , withThemeOptions, withComponentOptions, withApplicationOptions
    , Book
    )

{-| **Tip:** If you're just getting started, it's usually better to start by creating a chapter (checkout the `ElmBook.Chapter` module).

Check out the ["Books"](https://elm-book-in-elm-book.netlify.app/guides/books) guide for more examples.


# Creating your Book

This module is used to create your books main output. You need to list your book's chapters here and also provide any global options you may want to define.

    main : Book ()
    main =
        book "My Book"
            |> withChapters
                [ firstChapter
                , secondChapter
                ]

@docs book, withChapters, withChapterGroups


# Customizing your book

You can pipe any of the customization functions on your book's creation. Just make sure you're passing these functions before you call `withChapters` or `withChapterGroups` functions.

@docs withThemeOptions, withComponentOptions, withApplicationOptions


# Types

@docs Book

-}

import Browser exposing (UrlRequest(..))
import ElmBook.Custom
import ElmBook.Internal.Application exposing (BookApplication)
import ElmBook.Internal.ApplicationOptions
import ElmBook.Internal.Book exposing (BookBuilder(..))
import ElmBook.Internal.Chapter exposing (ChapterCustom(..), chapterWithGroup)
import ElmBook.Internal.Component
import ElmBook.Internal.Helpers exposing (applyAttributes)
import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.Internal.Theme
import Html exposing (Html)


{-| Defines a book with some state. If you're creating a stateful book, you will need to pass your `SharedState` as an argument.

    import FirstChapter
    import SecondChapter

    type alias SharedState =
        { firstChapter : FirstChapter.Model
        , secondChapter : SecondChapter.Model
        }

    initialState : SharedState
    initialState =
        { firstChapter = FirstChapter.init
        , secondChapter = SecondChapter.init
        }

    main : Book SharedState
    main =
        book "MyApp"
            |> withApplicationOptions
                [ ElmBook.Application.initialState
                    initialState
                ]

-}
type alias Book state =
    BookApplication state (Html (Msg state))


{-| Kickoff the creation of an ElmBook application.
-}
book : String -> BookBuilder state (Html (Msg state))
book =
    ElmBook.Custom.customBook identity


{-| List the chapters that should be displayed on your book. Checkout `ElmBook.Chapter` if you want to create a chapter.

**Should be used as the final step on your setup.**

-}
withChapters : List (ChapterCustom state html) -> BookBuilder state html -> BookApplication state html
withChapters chapters =
    withChapterGroups [ ( "", chapters ) ]


{-| Organize your book's chapters into groups.

**Should be used as the final step on your setup.**

    book "MyApp"
        |> withChapterGroups
            [ ( "Guides"
              , [ gettingStartedChapter
                , sendingRequestsChapter
                ]
              )
            , ( "UI Components"
              , [ buttonsChapter
                , formsChapter
                , ...
                ]
              )
            ]

-}
withChapterGroups :
    List ( String, List (ChapterCustom state html) )
    -> BookBuilder state html
    -> BookApplication state html
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


{-| You can customize your book with any of the options available on the `ElmBook.Theme` module. Take a look at the ["Theming"](https://elm-book-in-elm-book.netlify.app/guides/theming) guide for some examples.

    main : Book x
    main =
        book "My Themed Book"
            |> withThemeOptions
                [ ElmBook.Theme.background "slategray"
                , ElmBook.Theme.accent "white"
                ]
            |> withChapters []

-}
withThemeOptions : List ElmBook.Internal.Theme.Attribute -> BookBuilder state html -> BookBuilder state html
withThemeOptions themeAttributes (BookBuilder config) =
    BookBuilder
        { config | theme = applyAttributes themeAttributes config.theme }


{-| By default, your components will appear inside a card with some padding and a label at the top. You can customize all of that with this function and the attributes available on `ElmBook.Component`.

Please note that component options are "inherited". So you can override these options one a particular chapter and even on an specific component.

    main : Book ()
    main =
        book "My Book"
            |> withComponentOptions
                [ ElmBook.Component.background "black"
                , ElmBook.Component.hiddenLabel True
                ]
            |> withChapters [ ... ]

-}
withComponentOptions : List ElmBook.Internal.Component.Attribute -> BookBuilder state html -> BookBuilder state html
withComponentOptions componentAttributes (BookBuilder config) =
    BookBuilder
        { config
            | componentOptions =
                applyAttributes componentAttributes ElmBook.Internal.Component.defaultOverrides
                    |> ElmBook.Internal.Component.toValidOptions config.componentOptions
        }


{-| Application options are used to both set global elements to your book (e.g. these is where you should add your CSS resets) and also to define things needed for your live elm components, take a look at the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide for more details.

Attributes for this function are defined on `ElmBook.Application`.

    import Css.Global exposing (global)
    import Tailwind.Utilities exposing (globalStyles)

    type alias SharedState = { ... }

    initialState : SharedState
    initialState = ...

    main : Book SharedState
    main =
        book "MyApp"
            |> withApplicationOptions
                [ ElmBook.Application.globals
                    [ global globalStyles ]
                , ElmBook.Application.initialState
                    initialState
                ]

-}
withApplicationOptions :
    List (ElmBook.Internal.ApplicationOptions.Attribute state html)
    -> BookBuilder state html
    -> BookBuilder state html
withApplicationOptions applicationAttributes (BookBuilder config) =
    BookBuilder
        { config | application = applyAttributes applicationAttributes config.application }
