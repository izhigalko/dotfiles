local wibox = require("wibox")
local awful = require("awful")

local widget = require("awesome_config.widget")

local panels = {}

function panels.init(cfg)

    local promptbox = {}
    local layoutbox = {}
    local taglist = {}
    local tasklist = {}
    local _panels = {}

    for s = 1, screen.count() do

        _panels[s] = {}

        promptbox[s] = awful.widget.prompt()
        layoutbox[s] = awful.widget.layoutbox(s)
        taglist[s] = widget.taglist(s, awful.widget.taglist.filter.all, cfg.tag.taglist.buttons, {})
        tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, cfg.client.tasklist.buttons)

        _panels[s] = awful.wibox({ position = "bottom", screen = s, height=cfg.panel.height })

        local left_top_layout = wibox.layout.fixed.horizontal()
        left_top_layout:add(taglist[s])
        left_top_layout:add(layoutbox[s])
        left_top_layout:add(promptbox[s])
        left_top_layout:add(tasklist[s])

        local right_top_layout = wibox.layout.fixed.horizontal()
        if s == 1 then right_top_layout:add(wibox.widget.systray()) end
        --right_top_layout:add(text_clock)
        --right_top_layout:add(kbd_switcher.widget)


        local top_layout = wibox.layout.align.horizontal()
        top_layout:set_left(left_top_layout)
        top_layout:set_right(right_top_layout)

        _panels[s]:set_widget(top_layout)
    end

end

return panels