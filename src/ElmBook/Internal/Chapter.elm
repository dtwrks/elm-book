module ElmBook.Internal.Chapter exposing
    ( ChapterBuilder(..)
    , ChapterComponent
    , ChapterComponentView(..)
    , ChapterConfig
    , ChapterCustom(..)
    , chapterBreadcrumb
    , chapterTitle
    , chapterUrl
    , chapterWithGroup
    , groupTitle
    )

import ElmBook.Internal.Component exposing (ComponentOptions)
import ElmBook.Internal.Helpers exposing (toSlug)


type ChapterCustom state html
    = Chapter (ChapterConfig state html)


type ChapterBuilder state html
    = ChapterBuilder (ChapterConfig state html)


type alias ChapterConfig state html =
    { url : String
    , title : String
    , groupTitle : Maybe String
    , body : String
    , componentOptions : ComponentOptions
    , componentList : List (ChapterComponent state html)
    }


type alias ChapterComponent state html =
    { label : String
    , view : ChapterComponentView state html
    }


type ChapterComponentView state html
    = ChapterComponentViewStateless html
    | ChapterComponentViewStateful (state -> html)


chapterTitle : ChapterCustom state html -> String
chapterTitle (Chapter { title }) =
    title


chapterUrl : ChapterCustom state html -> String
chapterUrl (Chapter { url }) =
    url


groupTitle : ChapterCustom state html -> Maybe String
groupTitle (Chapter chapter) =
    chapter.groupTitle


chapterBreadcrumb : ChapterCustom state html -> String
chapterBreadcrumb (Chapter chapter) =
    chapter.groupTitle
        |> Maybe.map (\t -> t ++ " / ")
        |> Maybe.withDefault ""
        |> (\t -> t ++ chapter.title)


chapterWithGroup : String -> ChapterCustom state html -> ChapterCustom state html
chapterWithGroup group (Chapter chapter) =
    if group == "" then
        Chapter chapter

    else
        Chapter
            { chapter
                | groupTitle = Just group
                , url = "/" ++ toSlug group ++ chapter.url
            }
