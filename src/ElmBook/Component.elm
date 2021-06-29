module ElmBook.Component exposing
    ( Attribute
    , ComponentOptions
    , background
    , block
    , card
    , hiddenLabel
    , inline
    )

import ElmBook.Internal.Component exposing (ComponentOptions(..), Layout(..))


type alias ComponentOptions =
    ElmBook.Internal.Component.ComponentOptions


type alias Attribute =
    ComponentOptions -> ComponentOptions


background : String -> ComponentOptions -> ComponentOptions
background background_ (ComponentOptions settings) =
    ComponentOptions { settings | background = Just background_ }


hiddenLabel : Bool -> ComponentOptions -> ComponentOptions
hiddenLabel hiddenLabel_ (ComponentOptions settings) =
    ComponentOptions { settings | hiddenLabel = Just hiddenLabel_ }


inline : ComponentOptions -> ComponentOptions
inline (ComponentOptions settings) =
    ComponentOptions { settings | layout = Just Inline }


block : ComponentOptions -> ComponentOptions
block (ComponentOptions settings) =
    ComponentOptions { settings | layout = Just Block }


card : ComponentOptions -> ComponentOptions
card (ComponentOptions settings) =
    ComponentOptions { settings | layout = Just Card }
