module ElmBook.UI.Markdown exposing
    ( styles
    , view
    )

import Dict
import ElmBook.Msg exposing (Msg)
import ElmBook.UI.ChapterElement
import ElmBook.UI.Helpers exposing (css_, mediaLargeScreen)
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import SyntaxHighlight


view : String -> List ( String, Html (Msg state) ) -> String -> Html (Msg state)
view chapterTitle chapterElements =
    Markdown.Parser.parse
        >> Result.withDefault []
        >> Markdown.Renderer.render
            (sectionRenderer
                chapterTitle
                chapterElements
            )
        >> Result.withDefault []
        >> (\children ->
                article
                    []
                    [ div [] children
                    ]
           )


sectionRenderer : String -> List ( String, Html (Msg state) ) -> Markdown.Renderer.Renderer (Html (Msg state))
sectionRenderer chapterTitle chapterElements =
    { defaultRenderer
        | html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "element"
                    (\maybeLabel maybeBackground maybeFullWidth _ ->
                        let
                            section_ =
                                case maybeLabel of
                                    Just label_ ->
                                        Dict.fromList chapterElements
                                            |> Dict.get label_
                                            |> Maybe.map (\v -> ( label_, v ))

                                    Nothing ->
                                        List.head chapterElements
                        in
                        section_
                            |> Maybe.map
                                (ElmBook.UI.ChapterElement.view
                                    chapterTitle
                                    maybeBackground
                                )
                            |> Maybe.map
                                (\c ->
                                    div
                                        [ classList
                                            [ ( "elm-book__element-wrapper", True )
                                            , ( "full"
                                              , case maybeFullWidth of
                                                    Just _ ->
                                                        True

                                                    Nothing ->
                                                        False
                                              )
                                            ]
                                        ]
                                        [ c ]
                                )
                            |> Maybe.withDefault
                                (div
                                    [ class "elm-book__element-wrapper elm-book-sans elm-book__element-empty" ]
                                    [ text <| "\"" ++ Maybe.withDefault "" maybeLabel ++ "\" example not found." ]
                                )
                    )
                    |> Markdown.Html.withOptionalAttribute "with-label"
                    |> Markdown.Html.withOptionalAttribute "with-background"
                    |> Markdown.Html.withOptionalAttribute "with-full-width"
                , Markdown.Html.tag "all-elements"
                    (\maybeBackground maybeFullWidth _ ->
                        div
                            [ classList
                                [ ( "elm-book__element-wrapper", True )
                                , ( "full"
                                  , case maybeFullWidth of
                                        Just _ ->
                                            True

                                        Nothing ->
                                            False
                                  )
                                ]
                            ]
                            [ ul [ class "elm-book-md__element-list" ]
                                (List.map
                                    (\section ->
                                        li
                                            [ class "elm-book elm-book-md__element-list__item" ]
                                            [ ElmBook.UI.ChapterElement.view
                                                chapterTitle
                                                maybeBackground
                                                section
                                            ]
                                    )
                                    chapterElements
                                )
                            ]
                    )
                    |> Markdown.Html.withOptionalAttribute "with-background"
                    |> Markdown.Html.withOptionalAttribute "with-full-width"
                ]
    }


defaultRenderer : Markdown.Renderer.Renderer (Html msg)
defaultRenderer =
    { html = Markdown.Html.oneOf []
    , heading =
        \{ level, children } ->
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
            div [ class "elm-book-md" ] [ tag children ]
    , paragraph =
        \children ->
            div [ class "elm-book-md" ] [ p [ class "elm-book-serif" ] children ]
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
            div [ class "elm-book-md" ]
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
            div [ class "elm-book-md" ]
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
            div [ class "elm-book-md" ] [ Html.table [] children ]
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
.elm-book__element-wrapper {
    max-width: 720px;
    margin: 0 auto;
    padding-bottom: 36px;
}
.elm-book__element-wrapper.full {
    max-width: 100%;
}
.elm-book__element-empty {
    padding: 20px;
    background-color: #eaeaea;
    border-radius: 4px;
    border: 2px solid #dadada;
    color: #666;
}

.elm-book-md__element-list {
    list-style-type: none;
    margin: 0;
    padding: 0;
}
.elm-book-md__element-list__item {}

.elm-book-md {
    max-width: 720px;
    margin: 0 auto;
    padding-bottom: 36px;
}
.elm-book-md * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

""" ++ mediaLargeScreen ++ """ {
    .elm-book__element-wrapper {
        max-width: 960px;
    }
    .elm-book__element-wrapper.full {
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

.elm-book-md p {
    line-height: 1.8em;
    color: rgb(41, 41, 41);
    font-size: 21px;
}

.elm-book-md a {
    color: #000;
    text-decoration: underline;
}
.elm-book-md a:hover {
    opacity: 0.8;   
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
    padding: 0 12px;
    background-color: #eaeaea;
}
.elm-book-md img {
    max-width: 100%;
}
.elm-book-md ul {
    padding-left: 32px;
}
.elm-book-md ol {
    padding-left: 32px;
}

.elm-book-md hr {
    border: none;
    height: 2px;
    background-color: #f0f0f0;
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

.elm-book-md__code,
.elm-book-md__code code {
    font-size: 21px;
    line-height: 22px;
    padding: 36px 24px;
    background-color: #31353b;
    border-radius: 6px;
}
.elm-book-md__code-default {

}

.elm-book-md pre.elmsh {
    padding: 10px;
    margin: 0;
    text-align: left;
    overflow: auto;
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
    color: #75715e;
}
.elm-book-md .elmsh1 {
    color: #46f0ff;
}
.elm-book-md .elmsh2 {
    color: #46ff9a;
}
.elm-book-md .elmsh3 {
    color: #f92672;
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
