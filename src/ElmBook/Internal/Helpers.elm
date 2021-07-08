module ElmBook.Internal.Helpers exposing
    ( applyAttributes
    , toSlug
    )


toSlug : String -> String
toSlug =
    String.trim >> String.map toUrlSafe


toUrlSafe : Char -> Char
toUrlSafe c =
    if Char.isAlphaNum c then
        Char.toLower c

    else
        '-'


applyAttributes : List (a -> a) -> a -> a
applyAttributes fns a =
    List.foldl (<|) a fns
