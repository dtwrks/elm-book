module UIBook.UI.Chapter exposing (ChapterLayout(..), view)

import Css exposing (..)
import Html as Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.Msg exposing (Msg(..))
import UIBook.UI.ChapterSection as ChapterSection
import UIBook.UI.Helpers exposing (..)
import UIBook.UI.Markdown


type ChapterLayout
    = SingleColumn
    | TwoColumns


type alias Props state =
    { title : String
    , layout : ChapterLayout
    , description : Maybe String
    , backgroundColor : Maybe String
    , sections : List ( String, Html.Html (Msg state) )
    }


view : Props state -> Html (Msg state)
view props =
    let
        twoColumns : List Style -> Style
        twoColumns styles =
            if props.layout == TwoColumns then
                desktop styles

            else
                Css.batch []
    in
    article
        [ css
            [ insetZero
            , overflow auto
            ]
        ]
        [ div
            [ css
                [ scrollContent
                , twoColumns
                    [ displayFlex
                    , alignItems stretch
                    ]
                ]
            ]
            [ props.description
                |> Maybe.map
                    (\description_ ->
                        div
                            [ css
                                [ twoColumns
                                    [ Css.width (px 640)
                                    , maxWidth (pct 50)
                                    , scrollParent
                                    ]
                                ]
                            ]
                            [ div
                                [ css
                                    [ padding3 (px 22) (px 20) zero
                                    , twoColumns
                                        [ scrollContent ]
                                    ]
                                ]
                                [ UIBook.UI.Markdown.view
                                    props.title
                                    props.backgroundColor
                                    props.sections
                                    description_
                                ]
                            ]
                    )
                |> Maybe.withDefault (text "")
            , div
                [ css
                    [ twoColumns
                        [ flexGrow (num 1)
                        , scrollParent
                        ]
                    ]
                ]
                [ div
                    [ css
                        [ padding2 (px 24) (px 20)
                        , twoColumns
                            [ scrollContent
                            ]
                        ]
                    ]
                    [ sections props
                    ]
                ]
            ]
        ]



-- Helpers


sections : Props state -> Html (Msg state)
sections props =
    ul
        [ css
            [ flexGrow (num 1)
            , listStyleType none
            , padding zero
            , margin auto
            , maxWidth (px 720)
            ]
        ]
        (List.map
            (\section ->
                li
                    [ css
                        [ display block
                        , paddingBottom (px 24)
                        ]
                    ]
                    [ ChapterSection.view
                        props.title
                        props.backgroundColor
                        section
                    ]
            )
            props.sections
        )
