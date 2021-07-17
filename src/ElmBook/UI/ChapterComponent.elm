module ElmBook.UI.ChapterComponent exposing
    ( styles
    , view
    )

import ElmBook.Internal.ComponentOptions exposing (Layout(..), ValidComponentOptions)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.UI.Helpers exposing (css_)
import Html exposing (..)
import Html.Attributes exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book__chapter-component__title {
    padding-bottom: 12px;
    font-size: 14px;
    letter-spacing: 0.5px;
    color: #999;
}

.elm-book__chapter-component__background {
    padding: 12px;
    border-radius: 4px;
    background-color: #fff;
}
.elm-book-dark-mode .elm-book__chapter-component__background {
    background-color: #3b3f47;
}

.elm-book__chapter-component__content {
    border: 1px dashed transparent;
    position: relative;
}
.elm-book__chapter-component__content:hover {
    border-color: #eaeaea;
}
"""


viewLabel : ValidComponentOptions -> String -> Html (Msg state)
viewLabel options_ label =
    case ( label, options_.hiddenLabel, options_.display ) of
        ( "", _, _ ) ->
            text ""

        ( _, True, _ ) ->
            text ""

        ( _, _, Inline ) ->
            text ""

        _ ->
            p
                [ class "elm-book elm-book__chapter-component__title elm-book-sans"
                ]
                [ text label ]


viewBlock : ValidComponentOptions -> ( String, Html.Html (Msg state) ) -> Html (Msg state)
viewBlock options_ ( label, html ) =
    article
        [ class "elm-book__chapter-component" ]
        [ viewLabel options_ label
        , div [] [ html ]
        ]


viewCard : ValidComponentOptions -> ( String, Html.Html (Msg state) ) -> Html (Msg state)
viewCard options_ ( label, html ) =
    article
        [ class "elm-book__chapter-component" ]
        [ viewLabel options_ label
        , div
            [ class "elm-book__chapter-component__background elm-book-shadows-light"
            , style "background" options_.background
            ]
            [ div
                [ class "elm-book__chapter-component__content" ]
                [ html ]
            ]
        ]


viewDisplay : ValidComponentOptions -> ( String, Html.Html (Msg state) ) -> Html (Msg state)
viewDisplay options_ ( label, html ) =
    case options_.display of
        Inline ->
            html

        Block ->
            viewBlock options_ ( label, html )

        Card ->
            viewCard options_ ( label, html )


view : String -> ValidComponentOptions -> ( String, Html.Html (Msg state) ) -> Html (Msg state)
view chapterTitle options_ ( label, html ) =
    viewDisplay options_ ( label, html )
        |> Html.map
            (\msg ->
                let
                    actionContext =
                        if label /= "" then
                            chapterTitle ++ " / " ++ label ++ " / "

                        else
                            chapterTitle ++ " / "
                in
                case msg of
                    LogAction _ label_ ->
                        LogAction actionContext label_

                    _ ->
                        msg
            )
