module ElmBook.UI.ChapterComponent exposing
    ( styles
    , view
    )

import Browser
import ElmBook.Internal.Component exposing (ValidComponentOptions)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.UI.Helpers exposing (css_)
import Html exposing (..)
import Html.Attributes exposing (..)
import Url


styles : Html msg
styles =
    css_ """
.elm-book__chapter-component {}

.elm-book__chapter-component__title {
    padding-bottom: 12px;
    font-size: 14px;
    letter-spacing: 0.5px;
    color: #999;
}

.elm-book__chapter-component__background {
    padding: 12px;
    border-radius: 4px;
}
.elm-book__chapter-component__content {
    border: 1px dashed transparent;
    position: relative;
}
.elm-book__chapter-component__content:hover {
    border-color: #eaeaea;
}
"""


view : String -> ValidComponentOptions -> ( String, Html.Html (Msg state) ) -> Html (Msg state)
view chapterTitle options_ ( label, html ) =
    article
        [ class "elm-book__chapter-component" ]
        [ if options_.hiddenLabel || label == "" then
            text ""

          else
            p [ class "elm-book elm-book__chapter-component__title elm-book-sans" ] [ text label ]
        , div
            [ class "elm-book__chapter-component__background elm-book-shadows-light"
            , style "background" options_.background
            ]
            [ div
                [ class "elm-book__chapter-component__content" ]
                [ html ]
            ]
        ]
        |> Html.map
            (\msg ->
                let
                    _ =
                        Debug.log "msg" msg

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
