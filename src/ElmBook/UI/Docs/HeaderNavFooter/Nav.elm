module ElmBook.UI.Docs.HeaderNavFooter.Nav exposing (docs)

import ElmBook
import ElmBook.UI.Nav exposing (view)
import Html exposing (..)


docs : List ( String, Html (ElmBook.Msg x) )
docs =
    let
        itemGroup index =
            ( ""
            , [ ( String.fromInt index ++ "-first-slug", "First", True )
              , ( String.fromInt index ++ "-second-slug", "Second", True )
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
    [ ( "Nav", view props )
    , ( "Nav - Selected", view activeProps )
    , ( "Nav - Selected + Pre-selected", view { activeProps | preSelected = Just "0-second-slug" } )
    , ( "Nav w. groups"
      , view
            { activeProps
                | itemGroups =
                    List.range 0 3
                        |> List.map itemGroup
                        |> List.map (\( _, xs ) -> ( "Group Name", xs ))
            }
      )
    , ( "Nav w. unnamed groups"
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
