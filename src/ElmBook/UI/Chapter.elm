module ElmBook.UI.Chapter exposing
    ( styles
    , view
    )

import ElmBook.Internal.Chapter
import ElmBook.Internal.ComponentOptions
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.UI.Helpers exposing (..)
import ElmBook.UI.Markdown
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Props state =
    { title : String
    , chapterOptions : ElmBook.Internal.Chapter.ValidChapterOptions
    , componentOptions : ElmBook.Internal.ComponentOptions.ValidComponentOptions
    , body : String
    , components : List ( String, Html.Html (Msg state) )
    }


styles : Html msg
styles =
    css_ <| """
.elm-book-chapter {
    padding: 40px;
    width: 100%;
}
""" ++ mediaMobile ++ """ {
    .elm-book-chapter {
        padding: 24px;
    }
}
"""


view : Props state -> Html (Msg state)
view props =
    let
        body =
            if props.chapterOptions.hiddenTitle then
                props.body

            else
                "# " ++ props.title ++ "\n" ++ props.body
    in
    article
        [ class "elm-book elm-book-chapter" ]
        [ ElmBook.UI.Markdown.view
            props.title
            props.components
            props.componentOptions
            body
        ]
