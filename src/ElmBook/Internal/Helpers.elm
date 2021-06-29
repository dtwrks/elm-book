module ElmBook.Internal.Helpers exposing (toSlug)


toSlug : String -> String
toSlug =
    String.toLower >> String.replace " " "-"
