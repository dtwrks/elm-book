module ElmBook.UI.Docs.Guides.BuiltinServer exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render)


docs : Chapter x
docs =
    chapter "Development Server"
        |> render """
ElmBook is just pure Elm. You can use whatever setup you want to build it.

However, we also provide a zero-config dev server to make things easier. If you want to use it, just install `elm-book` as an npm devDependency then run…

```
npx elm-book {MyBookModule}.elm
```

…and you should see your brand new Book running in your browser!

---

## 🤫

I'll let you in on a secret… this is just an instance of [elm-live](https://www.elm-live.com) with a few predefined arguments passed in! So any additional arguments you pass to this command will work exactly like it would with elm-live, so

```bash
npx elm-book {MyBookModule}.elm --port=3000 --dir=./static
```

would start your development server on port 3000 with static files from the `./static` folder.        
"""
