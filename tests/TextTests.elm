module TextTests exposing (..)

import Dict
import Expect
import Json.Encode as E
import Test exposing (Test, test)
import Text



-- Upper camel case module names (the-sett/elm-string-case)
-- Lower camel case values and functions (the-sett/elm-string-case)


suite : Test
suite =
    test "Text.fromJson" <|
        \_ ->
            E.object
                [ ( "foo", E.string "bar" )
                , ( "temporality"
                  , E.object
                        [ ( "current_time", E.string "The time is {{ time }} now." )
                        , ( "current_date_and_time", E.string "The date is {{ date }} and the time is {{ time }}" )
                        , ( "date_formats"
                          , E.object
                                [ ( "year difference", E.string "The difference between {{ first_year }} and {{ second_year }} is {{ year_difference }}." )
                                ]
                          )
                        ]
                  )
                ]
                |> Text.fromJson
                |> Expect.equal
                    (Dict.fromList
                        [ ( [ "Text" ]
                          , Dict.fromList
                                [ ( "foo", [ Text.Static "bar" ] )
                                ]
                          )
                        , ( [ "Text", "temporality", "date_formats" ]
                          , Dict.fromList
                                [ ( "year difference"
                                  , [ Text.Static "The difference between "
                                    , Text.Parameter "first_year"
                                    , Text.Static " and "
                                    , Text.Parameter "second_year"
                                    , Text.Static " is "
                                    , Text.Parameter "year_difference"
                                    , Text.Static "."
                                    ]
                                  )
                                ]
                          )
                        , ( [ "Text", "temporality" ]
                          , Dict.fromList
                                [ ( "current_date_and_time"
                                  , [ Text.Static "The date is "
                                    , Text.Parameter "date"
                                    , Text.Static " and the time is "
                                    , Text.Parameter "time"
                                    ]
                                  )
                                , ( "current_time"
                                  , [ Text.Static "The time is "
                                    , Text.Parameter "time"
                                    , Text.Static " now."
                                    ]
                                  )
                                ]
                          )
                        ]
                    )