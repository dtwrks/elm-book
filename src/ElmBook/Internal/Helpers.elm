module ElmBook.Internal.Helpers exposing (applyAttributes, toSlug)


toSlug : String -> String
toSlug =
    String.toLower >> String.replace " " "-"


applyAttributes : List (a -> a) -> a -> a
applyAttributes fns a =
    List.foldl (<|) a fns
