module ElmBook exposing
    ( book, withChapters, withChapterGroups
    , withThemeOptions, withChapterOptions, withComponentOptions, withStatefulOptions
    , Book, Msg
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

@docs withThemeOptions, withChapterOptions, withComponentOptions, withStatefulOptions


# Types

@docs Book, Msg

-}

import Browser exposing (UrlRequest(..))
import ElmBook.ChapterOptions
import ElmBook.Custom exposing (BookBuilder)
import ElmBook.Internal.Application exposing (BookApplication)
import ElmBook.Internal.Book exposing (BookBuilder(..))
import ElmBook.Internal.Chapter exposing (ChapterCustom(..), chapterWithGroup)
import ElmBook.Internal.ComponentOptions
import ElmBook.Internal.Helpers exposing (applyAttributes)
import ElmBook.Internal.Msg
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import Html exposing (Html)


{-| Defines a book with some state and some type of expected html.

If you're working with something other than `elm/html` (e.g. elm-css or elm-ui) then check out the `ElmBook.Custom` module.

If you're creating a stateful book, you will need to pass your custom `SharedState` as an argument as showcased below.

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
            |> withStatefulOptions
                [ ElmBook.StatefulOptions.initialState
                    initialState
                ]

-}
type alias Book state =
    BookApplication state (Html (Msg state))


{-| -}
type alias Msg state =
    ElmBook.Internal.Msg.Msg state


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
withChapterGroups chapterGroups_ (BookBuilder config) =
    ElmBook.Internal.Application.application
        (chapterGroups_
            |> List.map
                (\( group, chapters ) ->
                    ( group
                    , List.map
                        (chapterWithGroup
                            config.themeOptions.routePrefix
                            group
                        )
                        chapters
                    )
                )
        )
        (BookBuilder config)


{-| You can customize your book with any of the options available on the `ElmBook.Theme` module. Take a look at the ["Theming"](https://elm-book-in-elm-book.netlify.app/guides/theming) guide for some examples.

    main : Book x
    main =
        book "My Themed Book"
            |> withThemeOptions
                [ ElmBook.ThemeOptions.globals [ myCssReset ]
                , ElmBook.ThemeOptions.background "slategray"
                , ElmBook.ThemeOptions.accent "white"
                ]
            |> withChapters []

-}
withThemeOptions : List (ElmBook.ThemeOptions.ThemeOption html) -> BookBuilder state html -> BookBuilder state html
withThemeOptions themeAttributes (BookBuilder config) =
    BookBuilder
        { config | themeOptions = applyAttributes themeAttributes config.themeOptions }


{-| By default, your chapter will display its title at the top of the content. You can disable this by passing in chapter options.

    book "My Book"
        |> withChapterOptions
            [ ElmBook.Chapter.hiddenTitle True
            ]
        |> withChapters []

Please note that chapter options are "inherited". So you can also override these options on a particular chapter and that will take priority of book-wide options. Take a look at `ElmBook.ChapterOptions` for all the options available.

-}
withChapterOptions : List ElmBook.ChapterOptions.Attribute -> BookBuilder state html -> BookBuilder state html
withChapterOptions attributes (BookBuilder config) =
    BookBuilder
        { config
            | chapterOptions =
                applyAttributes attributes ElmBook.Internal.Chapter.defaultOverrides
                    |> ElmBook.Internal.Chapter.toValidOptions config.chapterOptions
        }


{-| By default, your components will appear inside a card with some padding and a label at the top. You can customize all of that with this function and the attributes available on `ElmBook.ComponentOptions`.

    main : Book ()
    main =
        book "My Book"
            |> withComponentOptions
                [ ElmBook.Component.background "black"
                , ElmBook.Component.hiddenLabel True
                ]
            |> withChapters [ ... ]

Please note that component options are "inherited". So you can override these options on a particular chapter and even on an specific component.

-}
withComponentOptions : List ElmBook.Internal.ComponentOptions.Attribute -> BookBuilder state html -> BookBuilder state html
withComponentOptions componentAttributes (BookBuilder config) =
    BookBuilder
        { config
            | componentOptions =
                applyAttributes componentAttributes ElmBook.Internal.ComponentOptions.defaultOverrides
                    |> ElmBook.Internal.ComponentOptions.toValidOptions config.componentOptions
        }


{-| Stateful options are useful for interactive books. With them you can set your book's initialState or even give it your custom subscriptions. Take a look at the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide for more details.

Attributes for this function are defined on `ElmBook.StatefulOptions`.

-}
withStatefulOptions :
    List (ElmBook.StatefulOptions.Attribute state)
    -> BookBuilder state html
    -> BookBuilder state html
withStatefulOptions attributes (BookBuilder config) =
    BookBuilder
        { config | statefulOptions = applyAttributes attributes config.statefulOptions }
