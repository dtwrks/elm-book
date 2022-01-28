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
    , init
    , toValidOptions
    )

import ElmBook.Internal.ComponentOptions exposing (ComponentOptions)
import ElmBook.Internal.Helpers exposing (toSlug)
import ElmBook.Internal.Msg exposing (Msg)


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
    , init : Maybe (state -> ( state, Cmd (Msg state) ))
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


init : ChapterCustom state html -> Maybe (state -> ( state, Cmd (Msg state) ))
init (Chapter chapter) =
    chapter.init


chapterBreadcrumb : ChapterCustom state html -> String
chapterBreadcrumb (Chapter chapter) =
    chapter.groupTitle
        |> Maybe.map (\t -> t ++ " / ")
        |> Maybe.withDefault ""
        |> (\t -> t ++ chapter.title)


chapterWithGroup : String -> String -> ChapterCustom state html -> ChapterCustom state html
chapterWithGroup routePrefix group (Chapter chapter) =
    let
        groupPrefix =
            if group == "" then
                ""

            else
                "/" ++ toSlug group
    in
    if not chapter.internal then
        Chapter chapter

    else
        Chapter
            { chapter
                | groupTitle = Just group
                , url = routePrefix ++ groupPrefix ++ chapter.url
            }
