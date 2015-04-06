theme = {}

-- File path
theme.config_dir = os.getenv("HOME") .. "/.config/awesome"

-- Base theme values
theme.font          = "sans 11"

theme.bg_normal     = "#017783"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.wallpaper = theme.config_dir .. "/wallpapers/1.jpg"

theme.tag = {
    width = 90,
    font_color = "#e0e7ee",
    background_color = "#354e6a",
    mark_color = "#73c0c0",
    selected = {
        color = "#73c0c0"
    },
    urgent = {
        color = "#73c0c0"
    }
}

theme.taglist = {
    margins = {5, 5, 5, 5}
}

return theme