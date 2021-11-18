module ElmBook.Internal.Book exposing
    ( BookBuilder(..)
    , BookBuilderData
    , ElmBookConfig
    , chapterFromUrl
    , configFromBuilder
    )

import Array exposing (Array)
import Dict exposing (Dict)
import ElmBook.Internal.Chapter exposing (ChapterCustom, ValidChapterOptions, chapterUrl)
import ElmBook.Internal.ComponentOptions exposing (ValidComponentOptions)
import ElmBook.Internal.Msg exposing (Msg(..))
import ElmBook.Internal.StatefulOptions exposing (StatefulOptions)
import ElmBook.Internal.ThemeOptions exposing (ThemeOptions)
import Html exposing (Html)



-- Builder


type alias BookBuilderData state html subMsg =
    { title : String
    , toHtml : html -> Html (Msg state subMsg)
    , statefulOptions : StatefulOptions state subMsg
    , themeOptions : ThemeOptions html
    , chapterOptions : ValidChapterOptions
    , componentOptions : ValidComponentOptions
    }


type BookBuilder state html subMsg
    = BookBuilder (BookBuilderData state html subMsg)



-- Config


type alias ElmBookConfig state html subMsg =
    { title : String
    , toHtml : html -> Html (Msg state subMsg)
    , statefulOptions : StatefulOptions state subMsg
    , themeOptions : ThemeOptions html
    , chapterOptions : ValidChapterOptions
    , componentOptions : ValidComponentOptions
    , chapters : Array (ChapterCustom state html)
    , chapterGroups : List ( String, List Int )
    , chapterByUrl : Dict String Int
    }


configFromBuilder :
    List ( String, List (ChapterCustom state html) )
    -> BookBuilder state html subMsg
    -> ElmBookConfig state html subMsg
configFromBuilder chapterGroups_ (BookBuilder data) =
    let
        chapterData :
            { chapters : Array (ChapterCustom state html)
            , chapterByUrl : Dict String Int
            , chaptersCount : Int
            }
        chapterData =
            chapterGroups_
                |> List.foldl
                    (\( _, chapters_ ) acc ->
                        chapters_
                            |> List.foldl
                                (\c acc_ ->
                                    { chapters = Array.push c acc_.chapters
                                    , chapterByUrl =
                                        Dict.insert
                                            (chapterUrl c)
                                            acc_.chaptersCount
                                            acc_.chapterByUrl
                                    , chaptersCount = acc_.chaptersCount + 1
                                    }
                                )
                                { chapters = acc.chapters
                                , chapterByUrl = acc.chapterByUrl
                                , chaptersCount = acc.chaptersCount
                                }
                    )
                    { chapters = Array.empty
                    , chapterByUrl = Dict.empty
                    , chaptersCount = 0
                    }

        { chapters, chapterByUrl } =
            chapterData

        chapterGroups : List ( String, List Int )
        chapterGroups =
            let
                toIndexedGroup : Int -> ( String, List a ) -> ( String, List Int )
                toIndexedGroup initialIndex ( groupTitle, groupChapters ) =
                    ( groupTitle
                    , List.indexedMap (\i _ -> i + initialIndex) groupChapters
                    )
            in
            chapterGroups_
                |> List.foldl
                    (\( label, xs ) ( acc, lastIndex ) ->
                        ( toIndexedGroup lastIndex ( label, xs ) :: acc
                        , lastIndex + List.length xs
                        )
                    )
                    ( [], 0 )
                |> Tuple.first
                |> List.reverse
    in
    { title = data.title
    , toHtml = data.toHtml
    , statefulOptions = data.statefulOptions
    , themeOptions = data.themeOptions
    , chapterOptions = data.chapterOptions
    , componentOptions = data.componentOptions
    , chapters = chapters
    , chapterGroups = chapterGroups
    , chapterByUrl = chapterByUrl
    }



-- Helpers


chapterFromUrl : ElmBookConfig state html subMsg -> String -> Maybe (ChapterCustom state html)
chapterFromUrl config url =
    Dict.get url config.chapterByUrl
        |> Maybe.andThen (\i -> Array.get i config.chapters)
