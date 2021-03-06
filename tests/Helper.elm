module Helper exposing (..)

import Collection exposing (Collection)
import Dict
import Fuzz exposing (Fuzzer)
import Text exposing (Text)


singleTextModule : String -> List Text -> Collection (List Text)
singleTextModule key texts =
    Dict.fromList
        [ ( []
          , Dict.fromList
                [ ( key
                  , texts
                  )
                ]
          )
        ]


textFuzzer : Fuzzer String
textFuzzer =
    Fuzz.char
        |> Fuzz.map
            (\c ->
                if c == ' ' || c == '{' || c == '}' then
                    '-'

                else
                    c
            )
        |> nonEmptyFuzzer
        |> Fuzz.map String.fromList


nonEmptyFuzzer : Fuzzer a -> Fuzzer (List a)
nonEmptyFuzzer fuzzer =
    Fuzz.map2 (::) fuzzer (Fuzz.list fuzzer)
