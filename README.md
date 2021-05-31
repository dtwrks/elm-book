# UI Book

A book that tells the story of the UI elements of your Elm application.

- Plain Elm (no custom setup)
- Customizable theme colors and header
- Organize your UI elements into chapters and sections
- Showcase stateful widgets, not only static elements
- Log your actions
- Built-in integration with elm-ui, elm-css and others
- Built-in development server (Optional)

A live example can be found here: https://elm-ui-book.netlify.app/

## Start with a chapter.

You can create one chapter for each one of your UI elements and split it in sections to showcase all of their possible variants.

    buttonsChapter : UIChapter x
    buttonsChapter =
        chapter "Buttons"
            |> withSections
                [ ( "Default", button [] [] )
                , ( "Disabled", button [ disabled True ] [] )
                ]

Don't be limited by this pattern though. A chapter and its sections may be used however you want. For instance, if it's useful to have a catalog of possible colors or typographic styles in your documentation, why not dedicate a chapter to it?

## Then, create your book.

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

This returns a standard `Browser.application`. You can choose to use it just as you would any Elm application – however, this package can also be added as a NPM dependency to be used as zero-config dev server to get things started.

If you want to use our zero-config dev server, just install `elm-ui-book` as a devDependency then run `npx elm-ui-book {MyBookModule}.elm` and you should see your brand new Book running on your browser.

## Customize the book's style.

You can configure your book with a few extra settings to make it more personalized. Want to change the theme color so it's more fitting to your brand? Sure. Want to use your app's logo as the header? Go crazy.

    book "MyApp" ()
        |> withColor "#007"
        |> withSubtitle "Design System"
        |> withChapters [ ... ]

## Built-in integration with [elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest), [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) and others.

If you're using one of these two common ways of styling your Elm app, just import the proper definitions and you're good to go.

    import UIBook.ElmCSS exposing (UIBook, book)
    import UIBook exposing (withChapters)

    main : UIBook ()
    main =
        book "MyElmCSSApp" ()
            |> withChapters []

If you're using other packages that also work with a custom html, don't worry , defining a custom setup is pretty simple as well. Check the docs!

## Log your actions

Log your action intents to showcase how your components would react to interactions.

    -- Will log "Clicked!" after pressing the button
    button [ onClick <| logAction "Clicked!" ] []

    -- Will log "Input: x" after pressing the "x" key
    input [ onInput <| logActionWithString "Input: " ] []

## Showcase stateful widgets

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

## Built-in Development Server

If you want to use our zero-config dev server, just install `elm-ui-book` as an npm devDependency then run `npx elm-ui-book {MyBookModule}.elm` and you should see your brand new Book running on your browser.

🤫 I'll let you in on a secret… this is just an instance of [elm-live](https://www.elm-live.com) with a few predefined arguments passed in! So any additional arguments you pass to this command will work exactly like it would with elm-live, so `npx elm-ui-book {MyBookModule}.elm --port=3000 --dir=./static` would start your development server on port 3000 with static files from the `./static` folder.

## What's next?

So far this project has been following a lot of the same standards as [storybook](http://storybook.js.org/) – however, why should we limit ourselves by it? I'm thinking about exploring more book-like features that would make this project more useful for design systems and documentations and not only a library of UI components. Let's see! :)

If you have any ideas or problems, please reach me on Elm's slack as georgesboris.
