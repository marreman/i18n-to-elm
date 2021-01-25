module Elm exposing (..)

import Dict exposing (Dict)
import Elm.CodeGen exposing (..)
import Elm.Pretty
import Text exposing (Text)


type alias File =
    { name : String
    , path : List String
    , content : String
    }


fromText : Dict Text.Path Text.Module -> List File
fromText =
    Dict.foldl (\path mod files -> makeFile path mod :: files) []


makeFile : Text.Path -> Text.Module -> File
makeFile path mod =
    let
        path_ =
            "Text" :: path
    in
    { name = "name"
    , path = path_
    , content =
        file (normalModule path_ [])
            []
            (Dict.foldl (\name text d -> makeDeclaration name text :: d) [] mod)
            Nothing
            |> Elm.Pretty.pretty 80
    }


makeDeclaration : String -> List Text -> Declaration
makeDeclaration name texts =
    case texts of
        (Text.Static s) :: [] ->
            valDecl Nothing (Just stringAnn) name (string s)

        texts_ ->
            funDecl
                Nothing
                (Just
                    (funAnn (funAnn stringAnn (typeVar "a"))
                        (funAnn
                            (recordAnn
                                (List.filterMap
                                    (\text ->
                                        case text of
                                            Text.Parameter p ->
                                                Just ( p, typeVar "a" )

                                            Text.Static _ ->
                                                Nothing
                                    )
                                    texts_
                                )
                            )
                            (listAnn (typeVar "a"))
                        )
                    )
                )
                name
                [ varPattern "fromString", varPattern "parameters" ]
                (list <|
                    List.map
                        (\text ->
                            case text of
                                Text.Static s ->
                                    construct "fromString" [ string s ]

                                Text.Parameter p ->
                                    val ("parameters." ++ p)
                        )
                        texts_
                )



-- makeModule : String -> Text.Module -> Module
-- makeModule name module_ =
-- ("module " ++ name ++ " exposing (..)")
--     :: List.map toValue (Dict.toList values)
--     |> String.join "\n\n"
-- makeFunction : String -> List Ast.Part -> String
-- makeFunction name parts =
--     let
--         body =
--             List.foldl
--                 (\part bodySoFar ->
--                     case part of
--                         Ast.Text string ->
--                             ("fromString \"" ++ string ++ "\"") :: bodySoFar
--                         Ast.Parameter parameterName ->
--                             ("parameters." ++ parameterName) :: bodySoFar
--                 )
--                 []
--                 parts
--     in
--     name ++ " fromString parameters = " ++ String.join " ++ " (List.reverse body)
-- makeValue : String -> String -> String
-- makeValue name body =
--     name ++ " = " ++ "\"" ++ body ++ "\""
