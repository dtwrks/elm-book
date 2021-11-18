module ElmBook.Internal.Chapter exposing
    ( ChapterBuilder(..)
    , ChapterComponent
    , ChapterComponentView(..)
    , ChapterConfig
    , ChapterCustom(..)
    , ChapterOptions(..)
    , ValidChapterOptions
    , chapterBreadcrumb
    , chapterInternal
    , chapterNavUrl
    , chapterTitle
    , chapterUrl
    , chapterWithGroup
    , defaultOptions
    , defaultOverrides
    , groupTitle
    , map
    , toValidOptions
    )

import ElmBook.Internal.ComponentOptions exposing (ComponentOptions)
import ElmBook.Internal.Helpers exposing (toSlug)


type alias ValidChapterOptions =
    { hiddenTitle : Bool
    }


type ChapterOptions
    = ChapterOptions
        { hiddenTitle : Maybe Bool
        }


defaultOptions : ValidChapterOptions
defaultOptions =
    { hiddenTitle = False
    }


defaultOverrides : ChapterOptions
defaultOverrides =
    ChapterOptions
        { hiddenTitle = Nothing
        }


toValidOptions : ValidChapterOptions -> ChapterOptions -> ValidChapterOptions
toValidOptions valid (ChapterOptions options) =
    { hiddenTitle = Maybe.withDefault valid.hiddenTitle options.hiddenTitle
    }


map : (html -> mappedHtml) -> ChapterCustom state html -> ChapterCustom state mappedHtml
map mapFn (Chapter chapter) =
    Chapter
        { url = chapter.url
        , title = chapter.title
        , internal = chapter.internal
        , groupTitle = chapter.groupTitle
        , body = chapter.body
        , chapterOptions = chapter.chapterOptions
        , componentOptions = chapter.componentOptions
        , componentList = List.map (mapComponent mapFn) chapter.componentList
        }


mapComponent : (html -> mappedHtml) -> ChapterComponent state html -> ChapterComponent state mappedHtml
mapComponent mapFn component =
    { label = component.label
    , view =
        case component.view of
            ChapterComponentViewStateless statelessView ->
                ChapterComponentViewStateless (mapFn statelessView)

            ChapterComponentViewStateful statefulView ->
                ChapterComponentViewStateful (statefulView >> mapFn)
    }


type ChapterCustom state html
    = Chapter (ChapterConfig state html)


type ChapterBuilder state html
    = ChapterBuilder (ChapterConfig state html)


type alias ChapterConfig state html =
    { url : String
    , title : String
    , internal : Bool
    , groupTitle : Maybe String
    , body : String
    , chapterOptions : ChapterOptions
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


chapterInternal : ChapterCustom state html -> Bool
chapterInternal (Chapter { internal }) =
    internal


chapterNavUrl : Bool -> ChapterCustom state html -> String
chapterNavUrl hashBasedNavigation (Chapter { url, internal }) =
    if internal && hashBasedNavigation then
        "#" ++ url

    else
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
