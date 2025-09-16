module ElmBook.UI.Markdown exposing
    ( styles
    , view
    )

import Dict
import ElmBook.Internal.ComponentOptions exposing (Layout(..))
import ElmBook.Internal.Helpers exposing (toSlug)
import ElmBook.Internal.Msg exposing (Msg)
import ElmBook.UI.ChapterComponent
import ElmBook.UI.Helpers exposing (css_, mediaLargeScreen, mediaMobile)
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import SyntaxHighlight


view : Bool -> String -> List ( String, Html (Msg state) ) -> ElmBook.Internal.ComponentOptions.ValidComponentOptions -> String -> Html (Msg state)
view hashBasedNavigation chapterTitle chapterComponents componentOptions chapterContent =
    chapterContent
        |> Markdown.Parser.parse
        |> Result.mapError
            (\errors ->
                errors
                    |> List.map Markdown.Parser.deadEndToString
                    |> String.join "\n"
            )
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    (componentRenderer
                        hashBasedNavigation
                        chapterTitle
                        chapterComponents
                        componentOptions
                    )
                    blocks
            )
        |> (\result ->
                case result of
                    Ok children ->
                        article
                            []
                            [ div [] children
                            ]

                    Err errorString ->
                        div [ class "elm-book__component-wrapper" ]
                            [ pre
                                [ class "elm-book-sans elm-book__component-error" ]
                                [ text errorString ]
                            ]
           )


componentRenderer : Bool -> String -> List ( String, Html (Msg state) ) -> ElmBook.Internal.ComponentOptions.ValidComponentOptions -> Markdown.Renderer.Renderer (Html (Msg state))
componentRenderer hashBasedNavigation chapterTitle chapterComponents componentOptions =
    let
        defaultRenderer_ =
            defaultRenderer hashBasedNavigation
    in
    { defaultRenderer_
        | html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "component"
                    (\labelFilter hiddenLabel_ background_ display_ fullWidth_ _ ->
                        let
                            options_ =
                                ElmBook.Internal.ComponentOptions.markdownOptions
                                    componentOptions
                                    { hiddenLabel = hiddenLabel_
                                    , display = display_
                                    , background = background_
                                    , fullWidth = fullWidth_
                                    }

                            section_ =
                                case labelFilter of
                                    Just label_ ->
                                        Dict.fromList chapterComponents
                                            |> Dict.get label_
                                            |> Maybe.map (\v -> ( label_, v ))

                                    Nothing ->
                                        List.head chapterComponents
                        in
                        section_
                            |> Maybe.map (ElmBook.UI.ChapterComponent.view chapterTitle options_)
                            |> Maybe.map
                                (\c ->
                                    if options_.display == Inline then
                                        c

                                    else
                                        div
                                            [ classList
                                                [ ( "elm-book__component-wrapper", True )
                                                , ( "full", options_.fullWidth )
                                                ]
                                            ]
                                            [ c ]
                                )
                            |> Maybe.withDefault
                                (div [ class "elm-book__component-wrapper" ]
                                    [ div
                                        [ class "elm-book-sans elm-book__component-error" ]
                                        [ text <| "Oops!… \"" ++ Maybe.withDefault "" labelFilter ++ "\" component not found." ]
                                    ]
                                )
                    )
                    |> Markdown.Html.withOptionalAttribute "with-label"
                    |> Markdown.Html.withOptionalAttribute "with-hidden-label"
                    |> Markdown.Html.withOptionalAttribute "with-background"
                    |> Markdown.Html.withOptionalAttribute "with-display"
                    |> Markdown.Html.withOptionalAttribute "with-full-width"
                , Markdown.Html.tag "component-list"
                    (\labelFilter hiddenLabel_ background_ display_ fullWidth_ _ ->
                        let
                            options_ =
                                ElmBook.Internal.ComponentOptions.markdownOptions
                                    componentOptions
                                    { hiddenLabel = hiddenLabel_
                                    , display = display_
                                    , background = background_
                                    , fullWidth = fullWidth_
                                    }

                            components =
                                case labelFilter of
                                    Just s ->
                                        chapterComponents
                                            |> List.filter
                                                (Tuple.first >> String.startsWith s)

                                    Nothing ->
                                        chapterComponents
                        in
                        div
                            [ classList
                                [ ( "elm-book__component-wrapper", True )
                                , ( "full", options_.fullWidth )
                                ]
                            ]
                            [ ul [ class "elm-book-md__component-list" ]
                                (List.map
                                    (\section ->
                                        li
                                            [ class "elm-book elm-book-md__component-list__item" ]
                                            [ ElmBook.UI.ChapterComponent.view
                                                chapterTitle
                                                options_
                                                section
                                            ]
                                    )
                                    components
                                )
                            ]
                    )
                    |> Markdown.Html.withOptionalAttribute "with-label"
                    |> Markdown.Html.withOptionalAttribute "with-hidden-label"
                    |> Markdown.Html.withOptionalAttribute "with-background"
                    |> Markdown.Html.withOptionalAttribute "with-display"
                    |> Markdown.Html.withOptionalAttribute "with-full-width"
                ]
    }


defaultRenderer : Bool -> Markdown.Renderer.Renderer (Html msg)
defaultRenderer hashBasedNavigation =
    { html = Markdown.Html.oneOf []
    , heading =
        \{ level, rawText, children } ->
            let
                tag =
                    case level of
                        Block.H1 ->
                            h1 [ class "elm-book-serif" ]

                        Block.H2 ->
                            h2 [ class "elm-book-serif" ]

                        Block.H3 ->
                            h3 [ class "elm-book-serif" ]

                        Block.H4 ->
                            h4 [ class "elm-book-sans" ]

                        Block.H5 ->
                            h5 [ class "elm-book-sans" ]

                        Block.H6 ->
                            h6 [ class "elm-book-sans" ]
            in
            if hashBasedNavigation then
                div [ class "elm-book-md" ] [ tag children ]

            else
                let
                    headingId =
                        toSlug rawText
                in
                div
                    [ class "elm-book-md" ]
                    [ a [ href ("#" ++ headingId), id headingId, class "elm-book-md__heading-anchor" ] [ tag children ] ]
    , paragraph =
        \children ->
            div [ class "elm-book-md elm-book-serif elm-book-md__default" ] [ p [] children ]
    , hardLineBreak = div [ class "elm-book-md" ] [ br [] [] ]
    , blockQuote =
        \children ->
            div [ class "elm-book-md elm-book-serif" ]
                [ blockquote [] children
                ]
    , strong = strong []
    , emphasis = Html.em []
    , strikethrough = span []
    , codeSpan =
        \children ->
            span [ class "elm-book-md" ] [ code [ class "elm-book-monospace" ] [ text children ] ]
    , link =
        \link children ->
            a
                [ href link.destination
                , title (Maybe.withDefault "" link.title)
                ]
                children
    , image =
        \image ->
            div [ class "elm-book-md" ]
                [ img [ src image.src, alt image.alt, title <| Maybe.withDefault "" image.title ] []
                ]
    , text = text
    , unorderedList =
        \items ->
            div [ class "elm-book-md elm-book-serif elm-book-md__default" ]
                [ ul []
                    (items
                        |> List.map
                            (\item ->
                                case item of
                                    Block.ListItem task children ->
                                        let
                                            checkbox =
                                                case task of
                                                    Block.NoTask ->
                                                        text ""

                                                    Block.IncompleteTask ->
                                                        input
                                                            [ Attr.disabled True
                                                            , Attr.checked False
                                                            , type_ "checkbox"
                                                            ]
                                                            []

                                                    Block.CompletedTask ->
                                                        input
                                                            [ Attr.disabled True
                                                            , Attr.checked True
                                                            , type_ "checkbox"
                                                            ]
                                                            []
                                        in
                                        li [] (checkbox :: children)
                            )
                    )
                ]
    , orderedList =
        \startingIndex items ->
            div [ class "elm-book-md elm-book-serif elm-book-md__default" ]
                [ ol [ Attr.start startingIndex ]
                    (List.map (li []) items)
                ]
    , codeBlock =
        \{ body, language } ->
            let
                hCode =
                    case Maybe.withDefault "elm" language of
                        "elm" ->
                            SyntaxHighlight.elm body

                        "js" ->
                            SyntaxHighlight.javascript body

                        "json" ->
                            SyntaxHighlight.json body

                        "css" ->
                            SyntaxHighlight.css body

                        _ ->
                            SyntaxHighlight.noLang body
            in
            hCode
                |> Result.map (SyntaxHighlight.toBlockHtml Nothing)
                |> Result.map (\content -> div [ class "elm-book-md" ] [ div [ class "elm-book-md__code elm-book-monospace elm-book-shadows-light" ] [ content ] ])
                |> Result.withDefault
                    (div [ class "elm-book-md" ]
                        [ Html.pre [ class "elm-book-md__code-default elm-book-monospace elm-book-shadows-light" ] [ text body ]
                        ]
                    )
    , thematicBreak =
        div [ class "elm-book-md" ] [ hr [] [] ]
    , table =
        \children ->
            div [ class "elm-book-md elm-book-md__default elm-book-sans" ] [ Html.table [] children ]
    , tableHeader = thead []
    , tableBody = tbody []
    , tableRow = tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            th attrs
    , tableCell = \_ children_ -> td [] children_
    }


styles : Html msg
styles =
    css_ <| """
.elm-book__component-wrapper {
    max-width: 720px;
    margin: 0 auto;
    padding-bottom: 36px;
}
.elm-book__component-wrapper.full {
    max-width: 100%;
}
.elm-book__component-error {
    overflow: auto;
    padding: 20px;
    background-color: #f9e4b5;
    border-radius: 4px;
    border: 2px solid #eac97d;
    color: #ab7700;
}

.elm-book-md__component-list {
    list-style-type: none;
    margin: 0;
    padding: 0;
}
.elm-book-md__component-list__item + .elm-book-md__component-list__item {
    padding-top: 36px;
}

.elm-book-md {
    max-width: 720px;
    margin: 0 auto;
    padding-bottom: 36px;
    color: rgb(41,41,41);
}

.elm-book-dark-mode .elm-book-md {
    color: rgb(180, 180, 180);    
}

.elm-book-md * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
.elm-book-md .elm-book-md__heading-anchor {
    display: block;
    text-decoration: none;
    appearance: none;
    color: inherit;
    &:focus {
        outline: none;
    }
}

""" ++ mediaLargeScreen ++ """ {
    .elm-book__component-wrapper {
        max-width: 960px;
    }
    .elm-book__component-wrapper.full {
        max-width: 100%;
    }
    .elm-book-md {
        max-width: 960px;
    }
}

.elm-book-md h1 {
    font-size: 46px;
}
.elm-book-md h2 {
    font-size: 32px;
}
.elm-book-md h3 {
    font-size: 24px;
}
.elm-book-md h4 {
    font-size: 20px;
    font-weight: normal;
    text-transform: uppercase;
}
.elm-book-md h5 {
    font-size: 18px;
    font-weight: normal;
    text-transform: uppercase;
}
.elm-book-md h6 {
    font-size: 16px;
    font-weight: normal;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.elm-book-md h1,
.elm-book-md h2,
.elm-book-md h3 {
    font-weight: bold;
}

.elm-book-md h1,
.elm-book-md h2,
.elm-book-md h3,
.elm-book-md h4,
.elm-book-md h5,
.elm-book-md h6 {
    padding-top: 24px;
}

.elm-book-dark-mode .elm-book-md h1,
.elm-book-dark-mode .elm-book-md h2,
.elm-book-dark-mode .elm-book-md h3,
.elm-book-dark-mode .elm-book-md h4,
.elm-book-dark-mode .elm-book-md h5,
.elm-book-dark-mode .elm-book-md h6 {
    color: #dadada;
}

""" ++ mediaMobile ++ """ {
    .elm-book-md h1 {
        font-size: 40px;
        padding-top: 12px;
    }
}

.elm-book-md__default {
    line-height: 1.8em;
    color: rgb(80, 80, 90);
    font-size: 20px;
}
""" ++ mediaMobile ++ """ {
    .elm-book-md__default {
        font-size: 18px;
    }
}

.elm-book-md a {
    color: #000;
    text-decoration: underline;
}
.elm-book-md a:hover {
    opacity: 0.8;   
}
.elm-book-dark-mode .elm-book-md a {
    color: #f0f0f0;
}

.elm-book-md blockquote {
    font-size: 18px;
    margin-left: 0;
    padding: 8px 0 8px 24px;
    border-left: 4px solid #f0f0f0;
}
.elm-book-md code {
    display: inline-block;
    border-radius: 4px;
    padding: 0 8px;
    background-color: #f0f0f0;
    border: 1px solid #eaeaea;
    color: #4a4a4a;
    font-size: 0.8em;
    line-height: 1.8em;
}
.elm-book-dark-mode .elm-book-md code {
    background-color: #333;
    border: 1px solid #444;
    color: #bababa;
}


.elm-book-md img {
    max-width: 100%;
}
.elm-book-md ul {
    padding-left: 32px;
    list-style: disc;
}
.elm-book-md ol {
    padding-left: 32px;
}

.elm-book-md hr {
    border: none;
    height: 2px;
    background-color: #f0f0f0;
}
.elm-book-dark-mode .elm-book-md hr {
    background-color: #3b3f47;
}

.elm-book-md table {
    border-collapse: collapse;
    overflow-x: auto;
    border: 2px solid #f0f0f0;
}
.elm-book-md thead {
    border: none;
}
.elm-book-md tbody {
    border: none;
}
.elm-book-md tr {
    border: none;
    border-top: 2px solid #f0f0f0;
}
.elm-book-md th,
.elm-book-md td {
    border: none;
    border-right: 2px solid #f0f0f0;
    padding: 12px;
}
.elm-book-md th:last-child,
.elm-book-md td:last-child {
    border-right: none;
}

.elm-book-dark-mode .elm-book-md table,
.elm-book-dark-mode .elm-book-md tr,
.elm-book-dark-mode .elm-book-md th,
.elm-book-dark-mode .elm-book-md td {
    border-color: #3b3f47;
}

.elm-book-md__code,
.elm-book-md__code code,
.elm-book-dark-mode .elm-book-md__code,
.elm-book-dark-mode .elm-book-md__code code {
    font-size: 18px;
    line-height: 22px;
    padding: 20px 24px;
    background-color: #2a354d;
    border-radius: 6px;
    border: none;
    overflow: auto;
}
.elm-book-md__code-default {}

""" ++ mediaMobile ++ """ {
    .elm-book-md__code,
    .elm-book-md__code code,
    .elm-book-dark-mode .elm-book-md__code,
    .elm-book-dark-mode .elm-book-md__code code {
        font-size: 16px;
    }
}

.elm-book-md pre.elmsh {
    padding: 0;
    margin: 0;
}

.elm-book-md code.elmsh {
    padding: 0;
}

.elm-book-md .elmsh {
    color: #f8f8f2;
}
.elm-book-md .elmsh-hl {
    background: #343434;
}
.elm-book-md .elmsh-add {
    background: #003800;
}
.elm-book-md .elmsh-del {
    background: #380000;
}
.elm-book-md .elmsh-comm {
    color: #a4a39c;
}
.elm-book-md .elmsh1 {
    color: #46f0ff;
}
.elm-book-md .elmsh2 {
    color: #a5fb98;
}
.elm-book-md .elmsh3 {
    color: #ff8f00;
}
.elm-book-md .elmsh4 {
    color: #46f0ff;
}
.elm-book-md .elmsh5 {
    color: #46f0ff;
}
.elm-book-md .elmsh6 {
    color: #46f0ff;
}
.elm-book-md .elmsh7 {
    color: #46f0ff;
}
.elm-book-md .elmsh-elm-ts, .elm-book-md .elmsh-js-dk, .elm-book-md .elmsh-css-p {
    font-style: italic;
    color: #46f0ff;
}
.elm-book-md .elmsh-js-ce {
    font-style: italic;
    color: #46f0ff;
}
.elm-book-md .elmsh-css-ar-i {
    font-weight: bold;
    color: #46f0ff;
}
"""
