module ElmBook.Internal.Chapter exposing
    ( ChapterBuilder(..)
    , ChapterComponent
    , ChapterConfig
    , ChapterCustom(..)
    , chapterSlug
    , chapterTitle
    )

import ElmBook.Internal.Component exposing (ComponentOptions)


type ChapterCustom state html
    = Chapter (ChapterConfig state html)


type ChapterBuilder state html
    = ChapterBuilder (ChapterConfig state html)


type alias ChapterConfig state html =
    { title : String
    , slug : String
    , body : String
    , componentOptions : ComponentOptions
    , componentList : List (ChapterComponent state html)
    }


type alias ChapterComponent state html =
    { label : String
    , view : state -> html
    }


chapterTitle : ChapterCustom state html -> String
chapterTitle (Chapter { title }) =
    title


chapterSlug : ChapterCustom state html -> String
chapterSlug (Chapter { slug }) =
    slug
