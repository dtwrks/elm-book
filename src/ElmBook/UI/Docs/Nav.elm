module ElmBook.UI.Docs.Nav exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, renderComponentList, withComponentOptions)
import ElmBook.ComponentOptions
import ElmBook.UI.Helpers exposing (themeBackground)
import ElmBook.UI.Nav exposing (view)


docs : Chapter x
docs =
    let
        itemGroup index =
            ( ""
            , [ ( String.fromInt index ++ "-first-slug", "First" )
              , ( String.fromInt index ++ "-second-slug", "Second" )
              ]
            )

        props =
            { active = Nothing
            , preSelected = Nothing
            , itemGroups = List.singleton (itemGroup 0)
            }

        activeProps =
            { props | active = Just "0-first-slug" }
    in
    chapter "Nav"
        |> withComponentOptions
            [ ElmBook.ComponentOptions.background themeBackground
            ]
        |> renderComponentList
            [ ( "Default", view props )
            , ( "Selected", view activeProps )
            , ( "Selected + Pre-selected", view { activeProps | preSelected = Just "0-second-slug" } )
            , ( "With groups"
              , view
                    { activeProps
                        | itemGroups =
                            List.range 0 3
                                |> List.map itemGroup
                                |> List.map (\( _, xs ) -> ( "Group Name", xs ))
                    }
              )
            , ( "With unnamed groups"
              , view
                    { activeProps
                        | itemGroups =
                            List.range 0 3
                                |> List.map itemGroup
                                |> List.indexedMap
                                    (\index ( _, xs ) ->
                                        ( if index == 0 then
                                            ""

                                          else
                                            "Group Name"
                                        , xs
                                        )
                                    )
                    }
              )
            ]
