module ElmBook.Internal.Msg exposing (Msg(..), map)

import Browser exposing (UrlRequest)
import Url exposing (Url)


type Msg state msg
    = DoNothing
    | OnUrlRequest UrlRequest
    | OnUrlChange Url
    | GotCustomMsg msg
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


map : (msg -> mappedMsg) -> Msg state msg -> Msg state mappedMsg
map mapMsg msg =
    case msg of
        DoNothing ->
            DoNothing

        OnUrlRequest urlRequest ->
            OnUrlRequest urlRequest

        OnUrlChange url ->
            OnUrlChange url

        GotCustomMsg subMsg ->
            GotCustomMsg (mapMsg subMsg)

        UpdateState fn ->
            UpdateState (fn >> Tuple.mapSecond (Cmd.map (map mapMsg)))

        LogAction context action ->
            LogAction context action

        ToggleDarkMode ->
            ToggleDarkMode

        ActionLogShow ->
            ActionLogShow

        ActionLogHide ->
            ActionLogHide

        SearchFocus ->
            SearchFocus

        SearchBlur ->
            SearchBlur

        Search value ->
            Search value

        ToggleMenu ->
            ToggleMenu

        KeyArrowDown ->
            KeyArrowDown

        KeyArrowUp ->
            KeyArrowUp

        KeyShiftOn ->
            KeyShiftOn

        KeyShiftOff ->
            KeyShiftOff

        KeyMetaOn ->
            KeyMetaOn

        KeyMetaOff ->
            KeyMetaOff

        KeyEnter ->
            KeyEnter

        KeyK ->
            KeyK

        SetThemeBackgroundGradient startColor endColor ->
            SetThemeBackgroundGradient startColor endColor

        SetThemeBackground background ->
            SetThemeBackground background

        SetThemeAccent accent ->
            SetThemeAccent accent

        SetThemeNavBackground navBackground ->
            SetThemeNavBackground navBackground

        SetThemeNavAccent navAccent ->
            SetThemeNavAccent navAccent

        SetThemeNavAccentHighlight navAccentHighlight ->
            SetThemeNavAccentHighlight navAccentHighlight
