module ElmBook.UI.ChapterElement exposing
    ( styles
    , view
    )

import ElmBook.Msg exposing (Msg(..))
import ElmBook.UI.Helpers exposing (chapterSectionBackground, css_)
import Html exposing (..)
import Html.Attributes exposing (..)


styles : Html msg
styles =
    css_ """
.elm-book__chapter-element {
    padding-bottom: 24px;
}

.elm-book__chapter-element__title {
    padding-bottom: 12px;
    font-size: 14px;
    letter-spacing: 0.5px;
    color: #999;
}

.elm-book__chapter-element__background {
    padding: 12px;
    border-radius: 4px;
}
.elm-book__chapter-element__content {
    border: 1px dashed transparent;
    position: relative;
}
.elm-book__chapter-element__content:hover {
    border-color: #eaeaea;
}
"""


view : String -> Maybe String -> ( String, Html.Html (Msg state) ) -> Html (Msg state)
view chapterTitle backgroundColor_ ( label, html ) =
    article
        [ class "elm-book__chapter-element" ]
        [ if label == "" then
            text ""

          else
            p [ class "elm-book elm-book__chapter-element__title" ] [ text label ]
        , div
            [ class "elm-book__chapter-element__background elm-book-shadows-light"
            , style "background"
                (backgroundColor_
                    |> Maybe.withDefault chapterSectionBackground
                )
            ]
            [ div
                [ class "elm-book__chapter-element__content" ]
                [ html ]
            ]
        ]
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
