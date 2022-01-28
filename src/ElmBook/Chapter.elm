module ElmBook.Chapter exposing
    ( chapter, chapterLink, renderComponent, renderComponentList, Chapter, ChapterBuilder
    , withComponent, withComponentList, render, renderWithComponentList
    , withStatefulComponent, withStatefulComponentList, renderStatefulComponent, renderStatefulComponentList, withChapterInit
    , withChapterOptions, withComponentOptions
    )

{-| Chapters are what books are made of. They can be library guides, component examples, design tokens showcases, you name it.

Take a look at the ["Chapters"](https://elm-book-in-elm-book.netlify.app/guides/chapters) guide for a few examples.


# Getting started

Lets start by creating a chapter that displays different variants of a Button component:

    module UI.Button exposing (docs, view)

    import ElmBook.Actions exposing (logAction)
    import ElmBook.Chapter exposing (Chapter, chapter, renderComponentList)
    import Html exposing (..)
    import Html.Attributes exposing (..)
    import Html.Events exposing (onClick)

    view :
        { label : String
        , disabled : Bool
        , onClick : msg
        }
        -> Html msg
    view props =
        button
            [ class "px-8 py-3 rounded-md bg-indigo-200"
            , disabled props.disabled
            , onClick props.onClick
            ]
            [ text props.label ]

    docs : Chapter x
    docs =
        let
            props =
                { label = "Click me!"
                , disabled = False
                , onClick = logAction "Clicked button!"
                }
        in
        chapter "Buttons"
            |> renderComponentList
                [ ( "Default", view props )
                , ( "Disabled", view { props | disabled = True } )
                ]

**Tip:** Since Elm has amazing [dead code elimination](https://elm-lang.org/news/small-assets-without-the-headache#dead-code-elimination) you don't need to worry about splitting your component examples from your source code. They can live side by side making your development experience much better!

@docs chapter, chapterLink, renderComponent, renderComponentList, Chapter, ChapterBuilder


# Markdown and embedded components

You're not limited to creating these "storybook-like" chapters though. Take a look at the functions below and you will understand how to create richer docs based on markdown and embedded components.

@docs withComponent, withComponentList, render, renderWithComponentList


# Stateful Chapters

Create chapters with interactive components that can read and update the book's shared state. These functions work exactly like their stateless counterparts with the difference that they take the current state as an argument.

Take a look at the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide for a more throughout explanation.

@docs withStatefulComponent, withStatefulComponentList, renderStatefulComponent, renderStatefulComponentList, withChapterInit


# Customizing Chapters

@docs withChapterOptions, withComponentOptions

-}

import ElmBook.ChapterOptions
import ElmBook.Internal.Chapter exposing (ChapterBuilder(..), ChapterComponent, ChapterComponentView(..), ChapterCustom(..), ChapterOptions(..))
import ElmBook.Internal.ComponentOptions
import ElmBook.Internal.Helpers exposing (applyAttributes, toSlug)
import ElmBook.Internal.Msg exposing (Msg)
import Html exposing (Html)


{-| Defines a Chapter type. The argument is the shared state this chapter depends on. We can leave it blank (`x`) on stateless chapters. Read the ["Stateful Chapters"](https://elm-book-in-elm-book.netlify.app/guides/stateful-chapters) guide to know more.
-}
type alias Chapter state =
    ElmBook.Internal.Chapter.ChapterCustom state (Html (Msg state))


{-| The builder type for an incomplete chapter. Useful if you wanna reuse parts of your chapter setup pipeline across different chapters.
-}
type alias ChapterBuilder state html =
    ElmBook.Internal.Chapter.ChapterBuilder state html


{-| Creates a chapter with some title.
-}
chapter : String -> ChapterBuilder state html
chapter title =
    ChapterBuilder
        { title = title
        , groupTitle = Nothing
        , url = "/" ++ toSlug title
        , internal = True
        , body = ""
        , chapterOptions = ElmBook.Internal.Chapter.defaultOverrides
        , componentOptions = ElmBook.Internal.ComponentOptions.defaultOverrides
        , componentList = []
        , init = Nothing
        }


{-| Creates a chapter that links to an external resource.

**Note**: Chapter links are not like normal chapters – they are not rendered, they just serve as links to external resources through the book's navigation. Useful for things like linking to a library's elm-package page.

-}
chapterLink : { title : String, url : String } -> ChapterCustom state html
chapterLink props =
    Chapter
        { title = props.title
        , groupTitle = Nothing
        , url = props.url
        , internal = False
        , body = ""
        , chapterOptions = ElmBook.Internal.Chapter.defaultOverrides
        , componentOptions = ElmBook.Internal.ComponentOptions.defaultOverrides
        , componentList = []
        , init = Nothing
        }


{-| Adds a component to your chapter. You can display it using markdown.

    inputChapter : Chapter x
    inputChapter =
        chapter "Input"
            |> withComponent (input [] [])
            |> render """

    Take a look at this input:

    <component />

    """

-}
withComponent : html -> ChapterBuilder state html -> ChapterBuilder state html
withComponent html (ChapterBuilder builder) =
    ChapterBuilder
        { builder
            | componentList = fromTuple ( "", html ) :: builder.componentList
        }


{-| Adds multiple components to your chapter. You can display them using markdown.

    buttonsChapter : Chapter x
    buttonsChapter =
        chapter "Buttons"
            |> withComponentList
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]
            |> render """

    A button might be enabled:

    <component with-label="Default" />

    Or disabled:

    <component with-label="Disabled"

    """

-}
withComponentList : List ( String, html ) -> ChapterBuilder state html -> ChapterBuilder state html
withComponentList componentList (ChapterBuilder builder) =
    ChapterBuilder
        { builder
            | componentList =
                List.map fromTuple componentList ++ builder.componentList
        }


{-| Used for chapters with a single stateful component.
-}
withStatefulComponent : (state -> html) -> ChapterBuilder state html -> ChapterBuilder state html
withStatefulComponent view_ (ChapterBuilder builder) =
    ChapterBuilder
        { builder
            | componentList =
                { label = ""
                , view = ChapterComponentViewStateful view_
                }
                    :: builder.componentList
        }


{-| Used for chapters with multiple stateful components.
-}
withStatefulComponentList : List ( String, state -> html ) -> ChapterBuilder state html -> ChapterBuilder state html
withStatefulComponentList componentList (ChapterBuilder builder) =
    ChapterBuilder
        { builder
            | componentList =
                List.map fromTupleStateful componentList ++ builder.componentList
        }


{-| Used to create rich chapters with markdown and embedded components. Take a look at how you would list all buttons of the previous examples in one go:

    buttonsChapter : Chapter x
    buttonsChapter =
        chapter "Buttons"
            |> withComponentList
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]
            |> render """

        Look at all these buttons:

        <component-list />

    """

-}
render : String -> ChapterBuilder state html -> ChapterCustom state html
render body (ChapterBuilder builder) =
    Chapter
        { builder | body = builder.body ++ body }


{-| Render a single component with no markdown content.
-}
renderComponent : html -> ChapterBuilder state html -> ChapterCustom state html
renderComponent component (ChapterBuilder builder) =
    Chapter
        { builder
            | body = builder.body ++ "<component-list />"
            , componentList = fromTuple ( "", component ) :: builder.componentList
        }


{-| Render a list of components with no markdown content.
-}
renderComponentList : List ( String, html ) -> ChapterBuilder state html -> ChapterCustom state html
renderComponentList componentList (ChapterBuilder builder) =
    Chapter
        { builder
            | body = builder.body ++ "<component-list />"
            , componentList =
                List.map fromTuple componentList ++ builder.componentList
        }


{-| Render a single stateful component with no markdown content.
-}
renderStatefulComponent : (state -> html) -> ChapterBuilder state html -> ChapterCustom state html
renderStatefulComponent view_ (ChapterBuilder builder) =
    Chapter
        { builder
            | body = builder.body ++ "<component-list />"
            , componentList =
                { label = ""
                , view = ChapterComponentViewStateful view_
                }
                    :: builder.componentList
        }


{-| Render a list of stateful components with no markdown content.
-}
renderStatefulComponentList : List ( String, state -> html ) -> ChapterBuilder state html -> ChapterCustom state html
renderStatefulComponentList componentList (ChapterBuilder builder) =
    Chapter
        { builder
            | body = builder.body ++ "<component-list />"
            , componentList =
                List.map fromTupleStateful componentList ++ builder.componentList
        }


{-| Helper for creating chapters where all of the text content sits on top and all components at the bottom. It's basically an alias for what you just saw on the example above.

    buttonsChapter : Chapter x
    buttonsChapter =
        chapter "Buttons"
            |> withComponentList
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]
            |> renderWithComponentList
                "Look at all these buttons:"

-}
renderWithComponentList : String -> ChapterBuilder state html -> ChapterCustom state html
renderWithComponentList body (ChapterBuilder builder) =
    Chapter
        { builder | body = builder.body ++ body ++ "\n<component-list />" }



-- Customizing the chapter


{-| Use this to trigger a state change or command whenever this chapter is first rendered.
-}
withChapterInit :
    (state -> ( state, Cmd (Msg state) ))
    -> ChapterBuilder state html
    -> ChapterBuilder state html
withChapterInit init_ (ChapterBuilder builder) =
    ChapterBuilder { builder | init = Just init_ }


{-| By default, your chapter will display its title at the top of the content. You can disable this by passing in chapter options.

    chapter "Buttons"
        |> withChapterOptions
            [ ElmBook.Chapter.hiddenTitle True
            ]
        |> renderComponentList
            [ ( "Default", view props )
            , ( "Disabled", view { props | disabled = True } )
            ]

Please note that chapter options are "inherited". So your chapters will inherit from the options passed to your book by `ElmBook.withChapterOptions`. Take a look at `ElmBook.ChapterOptions` for the options available.

-}
withChapterOptions :
    List ElmBook.ChapterOptions.Attribute
    -> ChapterBuilder state html
    -> ChapterBuilder state html
withChapterOptions attributes (ChapterBuilder builder) =
    ChapterBuilder
        { builder
            | chapterOptions =
                applyAttributes attributes builder.chapterOptions
        }


{-| By default, your components will appear inside a card with some padding and a label at the top. You can customize all of that with this function and the attributes available on `ElmBook.Component`.

    chapter "Buttons"
        |> withComponentOptions
            [ ElmBook.Component.background "yellow"
            , ElmBook.Component.hiddenLabel True
            ]
        |> renderComponentList
            [ ( "Default", view props )
            , ( "Disabled", view { props | disabled = True } )
            ]

Please note that component options are "inherited". So your components will inherit from the options passed to your book by `ElmBook.withComponentOptions` and they can also be overriden on the component level. Take a look at the `ElmBook.Component` module for more details.

-}
withComponentOptions :
    List ElmBook.Internal.ComponentOptions.Attribute
    -> ChapterBuilder state html
    -> ChapterBuilder state html
withComponentOptions attributes (ChapterBuilder config) =
    ChapterBuilder
        { config
            | componentOptions =
                applyAttributes attributes config.componentOptions
        }



-- Helpers


fromTupleStateful : ( String, state -> html ) -> ChapterComponent state html
fromTupleStateful ( label, view_ ) =
    { label = label, view = ChapterComponentViewStateful view_ }


fromTuple : ( String, html ) -> ChapterComponent state html
fromTuple ( label, view_ ) =
    { label = label, view = ChapterComponentViewStateless view_ }
