module ElmBook.UI.Markdown exposing
    ( styles
    , view
    )

import Dict
import ElmBook.Msg exposing (Msg)
import ElmBook.UI.ChapterElement
import ElmBook.UI.Helpers exposing (css_)
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
                    [ styles
                    , SyntaxHighlight.useTheme SyntaxHighlight.gitHub
                    , div [ class "elm-book-md__wrapper" ] children
                    ]
           )



-- defaultPaddings : Style
-- defaultPaddings =
--     Css.batch
--         [ margin zero
--         , padding zero
--         , paddingBottom (px 24)
--         ]
-- defaultWidth : Style
-- defaultWidth =
--     Css.batch
--         [ Css.width (pct 100)
--         , maxWidth (px 720)
--         , margin2 zero auto
--         ]
-- fullWidth : Style
-- fullWidth =
--     Css.width (pct 100)
-- defaultFontStyles : Style
-- defaultFontStyles =
--     Css.batch
--         [ fontDefault
--         , fontSerif
--         , fontSize (px 16)
--         , lineHeight (Css.em 1.4)
--         ]
-- defaultStyles : Style
-- defaultStyles =
--     Css.batch
--         [ defaultFontStyles
--         , defaultWidth
--         , defaultPaddings
--         ]


sectionRenderer : String -> List ( String, Html (Msg state) ) -> Markdown.Renderer.Renderer (Html (Msg state))
sectionRenderer chapterTitle chapterElements =
    { defaultRenderer
        | html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "element"
                    (\maybeLabel maybeBackground _ ->
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
                            |> Maybe.withDefault (div [] [ text "Example not found." ])
                    )
                    |> Markdown.Html.withOptionalAttribute "with-label"
                    |> Markdown.Html.withOptionalAttribute "with-background"
                , Markdown.Html.tag "all-elements"
                    (\maybeBackground _ ->
                        ul [ class "elm-book" ]
                            (List.map
                                (\section ->
                                    li
                                        []
                                        [ ElmBook.UI.ChapterElement.view
                                            chapterTitle
                                            maybeBackground
                                            section
                                        ]
                                )
                                chapterElements
                            )
                    )
                    |> Markdown.Html.withOptionalAttribute "with-background"
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
                            h1 [ class "elm-book-sans" ]

                        Block.H2 ->
                            h2 [ class "elm-book-serif" ]

                        Block.H3 ->
                            h3 [ class "elm-book-serif" ]

                        Block.H4 ->
                            h4 [ class "elm-book-serif" ]

                        Block.H5 ->
                            h5 [ class "elm-book-sans" ]

                        Block.H6 ->
                            h6 [ class "elm-book-sans" ]
            in
            div [ class "elm-book-md" ] [ tag children ]
    , paragraph =
        \children ->
            div [ class "elm-book-md" ] [ p [] children ]
    , hardLineBreak = div [ class "elm-book-md" ] [ br [] [] ]
    , blockQuote =
        \children ->
            div [ class "elm-book-md" ]
                [ blockquote [] children
                ]
    , strong = strong []
    , emphasis = Html.em []
    , strikethrough = span []
    , codeSpan =
        \children ->
            div [ class "elm-book-md" ] [ code [] [ text children ] ]
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
                |> Result.map (\content -> div [ class "elm-book-md" ] [ div [ class "elm-book-md__code elm-book-mono elm-book-shadows-light" ] [ content ] ])
                |> Result.withDefault
                    (div [ class "elm-book-md" ]
                        [ Html.pre [ class "elm-book-md__code-default elm-book-mono elm-book-shadows-light" ] [ text body ]
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
    css_ """
.elm-book-md h1 {
    font-size: 24px;
}
.elm-book-md h2 {
    font-size: 22px;
}
.elm-book-md h3 {
    font-size: 18px;
}
.elm-book-md h4 {
    font-size: 16px;
}
.elm-book-md h5 {
    font-size: 14px;
    text-transform: uppercase;
}
.elm-book-md h6 {
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
.elm-book-md p {
    line-height: 1.8em;
    color: #666;
}
.elm-book-md blockquote {
    font-style: italic;
    font-size: 24px;
    padding-left: 24px;
    border-left: 4px solid #f0f0f0;
}
.elm-book-md code {
    display: inline-block;
    border-radius: 2px;
    padding: 0 8px;
    color: #dadada;
    backgroundColor: #282c34;
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
.elm-book-md__code {
    margin-bottom: 24px;
    font-size: 16px;
    padding: 16px 24px;
    background-color: #fff;
    border-radius: 6px;
}
.elm-book-md__code-default {

}
.elm-book-md hr {
    border: none;
    height: 2px;
    background-color: #f0f0f0;
}

.elm-book-md table {
    overflow-x: auto;
    border: 2px solid #f0f0f0;
}
.elm-book-md thead {
    border: 2px solid #f0f0f0;
}
.elm-book-md tbody {
    border: 2px solid #f0f0f0;
}
.elm-book-md tr {
    border: 2px solid #f0f0f0;
}
.elm-book-md th {
    border: 2px solid #f0f0f0;
    padding: 8px;
}
.elm-book-md td {
    border: 2px solid #f0f0f0;
    padding: 8px;
}
"""
