module ElmBook.Internal.Msg exposing (Msg(..))

import Browser exposing (UrlRequest)
import Url exposing (Url)


type Msg state msg
    = DoNothing
    | OnUrlRequest UrlRequest
    | OnUrlChange Url
    | GenericMsg msg
    | UpdateState (state -> ( state, Cmd (Msg state msg) ))
    | LogAction String String
    | ToggleDarkMode
    | ActionLogShow
    | ActionLogHide
    | SearchFocus
    | SearchBlur
    | Search String
    | ToggleMenu
    | KeyArrowDown
    | KeyArrowUp
    | KeyShiftOn
    | KeyShiftOff
    | KeyMetaOn
    | KeyMetaOff
    | KeyEnter
    | KeyK
    | SetThemeBackgroundGradient String String
    | SetThemeBackground String
    | SetThemeAccent String
    | SetThemeNavBackground String
    | SetThemeNavAccent String
    | SetThemeNavAccentHighlight String
