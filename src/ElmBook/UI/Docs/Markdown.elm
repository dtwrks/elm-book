module ElmBook.UI.Docs.Markdown exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render)


docs : Chapter x
docs =
    chapter "Markdown"
        |> render """
We use the amazing [dillonkearns/elm-markdown](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/) as the basis for not only our markdown content but also all the magic surrounding embedded components. Thanks, Dillon! 🎉

Below is a sample of most if not all available tags. Check it out! 🙃

---

# Heading 1

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

## Heading 2

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

### Heading 3

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

---

#### Heading 4

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

##### Heading 5

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

###### Heading 6

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

---

# Heading 1

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

![image](https://source.unsplash.com/WLUHO9A_xik/1600x900)

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Lorem ipsum dolor sit amet, `consectetur adipiscing elit`, [sed do eiusmod](http://elm-lang.org) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

```elm
-- Elm

view : String -> Html msg
view content =
    ElmBook.UI.Markdown.view content
        |> withOther "stuff"
        |> withAnd [ "x" [] ]
```

```html
<!-- HTML -->

<body>
    <h1>Title</h1>
</body>
```

```css
/* CSS */

body {
    margin: 0;
    padding: 0;
}
```


```js
// Javascript

import { Elm } from "..";

const app = Elm.Main.init({
    node: document.getElementById('myapp')
});
```

```js
// Typescript

interface User {
  name: string;
  id: number;
}

class UserAccount {
  name: string;
  id: number;

  constructor(name: string, id: number) {
    this.name = name;
    this.id = id;
  }
}

const user: User = new UserAccount("Murphy", 1);
```

```rust
// Rust (Unknown)

fn used_function() {}

// `#[allow(dead_code)]` is an attribute that disables the `dead_code` lint
#[allow(dead_code)]
fn unused_function() {}

fn noisy_unused_function() {}
// FIXME ^ Add an attribute to suppress the warning

fn main() {
    used_function();
}
```

---

# Heading 1

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

* Lorem ipsum dolor sit amet, consectetur adipiscing elit.
* Lorem ipsum dolor sit amet, consectetur adipiscing elit.
* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.

1. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
1. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

| Fruits    |      Are      |   Healthy  |
|----------|:-------------:|------:|
| Apple |  Red | $1600 |
| Orange |    Orange   |   $12 |
| Banana | Yellow |    $1 |  
"""
