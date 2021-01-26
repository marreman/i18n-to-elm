module ElmTests exposing (..)

import Dict
import Elm
import Expect
import Test exposing (Test, test)
import Text


suite : Test
suite =
    test "Text.fromJson" <|
        \_ ->
            Dict.fromList
                [ ( []
                  , Dict.fromList
                        [ ( "foo", [ Text.Static "bar" ] )
                        ]
                  )
                , ( [ "temporality", "date_formats" ]
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
                , ( [ "temporality" ]
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
                |> Elm.fromText
                |> Expect.equal
                    [ { content = module1, name = "DateFormats", path = [ "Text", "Temporality", "DateFormats" ] }
                    , { content = module2, name = "Temporality", path = [ "Text", "Temporality" ] }
                    , { content = module3, name = "Text", path = [ "Text" ] }
                    ]


module1 : String
module1 =
    """module Text.Temporality.DateFormats exposing (..)


yearDifference : (String -> a) -> { first_year : a, second_year : a, year_difference : a } -> List a
yearDifference fromString parameters =
    [ fromString "The difference between "
    , parameters.first_year
    , fromString " and "
    , parameters.second_year
    , fromString " is "
    , parameters.year_difference
    , fromString "."
    ]
"""


module2 : String
module2 =
    """module Text.Temporality exposing (..)


currentTime : (String -> a) -> { time : a } -> List a
currentTime fromString parameters =
    [ fromString "The time is ", parameters.time, fromString " now." ]


currentDateAndTime : (String -> a) -> { date : a, time : a } -> List a
currentDateAndTime fromString parameters =
    [ fromString "The date is ", parameters.date, fromString " and the time is ", parameters.time ]
"""


module3 : String
module3 =
    """module Text exposing (..)


foo : String
foo =
    "bar"
"""
