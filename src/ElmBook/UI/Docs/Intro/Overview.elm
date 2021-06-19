module ElmBook.UI.Docs.Intro.Overview exposing (..)

import ElmBook exposing (UIChapter, chapter, render)
import Html exposing (..)
import Html.Attributes exposing (..)


docs : UIChapter x
docs =
    chapter "Overview"
        |> render """
# Overview

Every application, tool or team has their own history worth telling.

ElmBook tries to help them by making it easy to create rich documents that showcase their **libraries documentations**, **UI elements**, **design tokens**, or anything else really.

---

## It all starts with a chapter

They can be as simple as a markdown block or as rich as a set of UI elements that interact with each other. Take a look at the ["Creating Chapters"](/chapter/guides--creating-chapters) guide for more details.

```elm
module FirstChapter exposing (chapter)


import ElmBook


content : String
content = \"\"\"

# It all starts with a chapter

They can be as simple as …

\"\"\"


chapter : ElmBook.Chapter x
chapter =
    ElmBook.chapter "The First Chapter"
        |> render content


```

---

## Together, they become a book

A book can hold a number of chapters and there are many ways to customize it from chapter grouping to custom themes. Take a look at the ["Creating Books"](/chapter/guides--creating-books) and ["Theming"](/chapter/guides--theming) guides for more details.


```elm
module Book exposing (main)


import ElmBook
import FirstChapter


main : ElmBook.Book ()
main =
    ElmBook.book "Book"
        |> withChapters [
            FirstChapter.chapter
        ]

```

---

### Inspiration

This library takes a lot of inspiration from both [Storybook](http://storybook.js.org) and [HexDocs](http://hexdocs.pm) but it does not try to replicate their features. I really hope we can create something unique to the Elm ecosystem here, so please let me know what you think, ideas to improve it or if you encountered any problems. Find me as **georgesboris** on Elm Slack.


"""
