module ElmBook.UI.Docs.Markdown exposing (..)

import ElmBook.Chapter exposing (Chapter, chapter, render)


docs : Chapter x
docs =
    chapter "Markdown"
        |> render """
# Heading 1

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

## Heading 2

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

### Heading 3

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

---

#### Heading 4

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

##### Heading 5

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

###### Heading 6

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

---

# Heading 1

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

![image](https://source.unsplash.com/WLUHO9A_xik/1600x900)

Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Lorem ipsum dolor sit amet, `consectetur adipiscing elit`, [sed do eiusmod](http://xxx.xxx) tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

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

| Característica da contratação e aquisição                 | Divulgação                                     | Método de seleção                                                                                   |
| --------------------------------------------------------- | ---------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Consultoria (serviços de baixa complexidade)              | Trabalhe Conosco (site do Idec) e de parceiros | Contratação simplificada de consultoria pessoa jurídica ou contratação de consultor individual (PF) |
| Consultoria (equipe multidisciplinar, serviços complexos) | Trabalhe Conosco (site do Idec) e de parceiros | Contratação de pessoa jurídica – Qualidade e preço                                                  |
| Bens de produção contínua                                 | Carta convite, pesquisa em sites               | Compra direta                                                                                       |
|                                                           | Carta convite, pesquisa em sites               | Comparação de preços e qualidade de pelo menos 3 fornecedores qualificados                          |
| Bens sob encomenda                                        | Carta convite, pesquisa em sites               | Compra direta                                                                                       |
|                                                           | Carta convite, pesquisa em sites               | Comparação de preços e qualidade de pelo menos 3 fornecedores qualificados                          |
| Serviços de natureza continuada                           | Carta convite, pesquisa em sites               | Contratação direta                                                                                  |
|                                                           | Carta convite, pesquisa em sites               | Comparação de preços e qualidade de pelo menos 3 fornecedores qualificados                          |   
"""
