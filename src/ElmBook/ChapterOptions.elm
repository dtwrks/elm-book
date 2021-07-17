module ElmBook.ChapterOptions exposing
    ( hiddenTitle
    , Attribute
    )

{-| Attributes used by `ElmBook.withChapterOptions` and `ElmBook.Chapter.withChapterOptions`.

@docs hiddenTitle


# Types

@docs Attribute

-}

import ElmBook.Internal.Chapter exposing (ChapterOptions(..))


{-| -}
type alias Attribute =
    ElmBook.Internal.Chapter.ChapterOptions -> ElmBook.Internal.Chapter.ChapterOptions


{-| Hides the chapter title at the top of the content.
-}
hiddenTitle : Bool -> Attribute
hiddenTitle hiddenTitle_ (ChapterOptions options) =
    ChapterOptions { options | hiddenTitle = Just hiddenTitle_ }
