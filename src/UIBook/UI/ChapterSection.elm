module UIBook.UI.ChapterSection exposing (view)

import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.Msg exposing (Msg(..))
import UIBook.UI.Helpers
    exposing
        ( chapterSectionBackground
        , fontLabel
        , shadowsLight
        )


view : String -> Maybe String -> ( String, Html.Html (Msg state) ) -> Html (Msg state)
view chapterTitle chapterBackgroundColor ( label, html ) =
    article
        [ css
            [ display block
            , paddingBottom (px 24)
            ]
        ]
        [ if label == "" then
            text ""

          else
            p
                [ css
                    [ margin zero
                    , padding zero
                    , paddingBottom (px 12)
                    , fontLabel
                    , color (hex "#999")
                    ]
                ]
                [ text label ]
        , div
            [ css
                [ padding (px 12)
                , borderRadius (px 4)
                , shadowsLight
                ]
            , style "background"
                (chapterBackgroundColor
                    |> Maybe.withDefault chapterSectionBackground
                )
            ]
            [ div
                [ css
                    [ border3 (px 1) dashed transparent
                    , position relative
                    , hover
                        [ borderColor (hex "#eaeaea")
                        ]
                    ]
                ]
                [ Html.Styled.fromUnstyled html ]
            ]
        ]
        |> Html.Styled.map
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
