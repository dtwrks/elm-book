module UIBook.UI.ChapterHeader exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import UIBook.UI.Helpers exposing (fontDefault)


view : String -> Html msg
view title_ =
    h1
        [ css
            [ margin zero
            , padding (px 16)
            , fontDefault
            , fontSize (px 20)
            , color (hex "#333")
            ]
        ]
        [ text title_ ]
