module ElmBook.Component exposing (background, hiddenLabel, block, inline, card)

{-| Attributes used by `ElmBook.withComponentOptions` and `ElmBook.Chapter.withComponentOptions`.

By default, your components will appear inside a card with some padding and a label at the top. You can customize all of that with these module's functions.

Customizations might be applied for your whole book, for a particular chapter or even for a particular component.

    main : Book ()
    main =
        book "My Book"
            |> withComponentOptions
                [ ElmBook.Component.background "black"
                , ElmBook.Component.hiddenLabel True
                ]
            |> withChapters [ ... ]

This is the API used for defining attributes on a component level (only works for components embedded in markdown):

    <component
        with-label="Some Component"
        with-hidden-label="true"
        with-display="block"
        with-background="yellow" />

@docs background, hiddenLabel, block, inline, card

-}

import ElmBook.Internal.Component exposing (ComponentOptions(..), Layout(..))


type alias ComponentOptions =
    ElmBook.Internal.Component.ComponentOptions


{-| Customize the background color of the card that wraps your components.

Available as `with-background=<string>` on embbeded components.

-}
background : String -> ComponentOptions -> ComponentOptions
background background_ (ComponentOptions settings) =
    ComponentOptions { settings | background = Just background_ }


{-| Hide the label that usually appears at the top of your components.

Available as `with-background=<"true" | "false">` on embbeded components

-}
hiddenLabel : Bool -> ComponentOptions -> ComponentOptions
hiddenLabel hiddenLabel_ (ComponentOptions settings) =
    ComponentOptions { settings | hiddenLabel = Just hiddenLabel_ }


{-| Make your components appear inline in your chapter. This is mostly useful when embedding components inside markdown.

Available as `with-display="inline"` on embbeded components

-}
inline : ComponentOptions -> ComponentOptions
inline (ComponentOptions settings) =
    ComponentOptions { settings | display = Just Inline }


{-| Removes the card that usually wraps your components.

Available as `with-display="block"` on embbeded components

-}
block : ComponentOptions -> ComponentOptions
block (ComponentOptions settings) =
    ComponentOptions { settings | display = Just Block }


{-| Place your components inside a card with some padding. This is the default behavior, you can use this attribute to bypass a higher-level definition.

Available as `with-display="card"` on embbeded components

-}
card : ComponentOptions -> ComponentOptions
card (ComponentOptions settings) =
    ComponentOptions { settings | display = Just Card }
