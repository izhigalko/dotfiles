local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

local beautiful = require("beautiful")
local tyrannical = require("tyrannical")
local lain = require("lain")
local config = require("awesome_config")

local cfg = {
    modkey = "Mod4",
    terminal = "urxvt",
    keyboard_layouts = {{"us", "", "EN"}, {"ru,us", "", "RU"}},
    home_dir = os.getenv("HOME"),
}

-- Panels settings
cfg.panel = {
    height = 40
}

-- Tags and taglist settings
cfg.tag = {
    taglist = {
        buttons = awful.util.table.join(
            awful.button({ }, 1, awful.tag.viewonly),
            awful.button({ cfg.modkey }, 1, awful.client.movetotag)
        ),
    }
}

-- Client and tasklist settings
cfg.client = {
    tasklist = {
        buttons = awful.util.table.join(
            awful.button({ }, 1, function (c)
                c.minimized = false
                if not c:isvisible() then
                  awful.tag.viewonly(c:tags()[1])
                end
                client.focus = c
                c:raise()
            end)
        )
    }
}

-- Tags settings

tyrannical.tags = {
    {
        name = "Term",
        init = true,
        exclusive = true,
        selected = true,
        force_screen = true,
        screen = 1,
        layout = lain.layout.uselessfair,
        class = {"urxvt", "URxvt"}
    },
    {
        name = "IM0",
        init = true,
        exclusive = true,
        force_screen = true,
        screen = 1,
        layout = awful.layout.suit.tile.bottom,
        class = {"viber", "Viber", "skype", "Skype", "ViberPC"}
    },
    {
        name = "IM1",
        init = true,
        exclusive = true,
        force_screen = true,
        screen = 1,
        layout = awful.layout.suit.tile.bottom,
        class = {"hexchat", "HexChat", "pidgin", "Pidgin"}
    },
    {
        name = "Sys",
        init = true,
        locked = true,
        force_screen = true,
        screen = 1,
        layout = awful.layout.suit.max
    },
    {
        name = "Virt",
        init = true,
        exclusive = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max,
        class = {"VirtualBox"}
    },
    {
        name = "Dev0",
        init = true,
        exclusive = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max,
        class = {"jetbrains-pycharm"}
    },
    {
        name = "Dev1",
        init = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max
    },
    {
        name = "WWW",
        init = true,
        exclusive = true,
        selected = screen.count() > 1 and true or false,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max,
        class = {"Chromium"}
    },
    {
        name = "Fall",
        init = false,
        fallback = true,
        force_screen = true,
        screen = screen.count() > 1 and {1, 2} or 1
    }
}

tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true
tyrannical.properties.size_hints_honor = { Rxvt = false }

-- / Tags settings

beautiful.init(cfg.home_dir .. "/.config/awesome/theme.test.lua")

for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

config.notification.init(cfg)
config.panels.init(cfg)