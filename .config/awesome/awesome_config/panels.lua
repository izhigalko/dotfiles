local wibox = require('wibox')
local awful = require('awful')
local beautiful = require("beautiful")
local lain = require('lain')
local widgets = require('config.widgets')

local panels = {}

function panels.init(cfg)

    local promptbox = {}
    local layoutbox = {}
    local taglist = {}
    local taglistwidget = {}
    local tasklist = {}
    local _panels = {}
    local theme = beautiful.get()
    local widget_margin = theme.widget_margin or 5
    local widget_background = theme.widget_bg or '#FFFFFF'

    taglist.buttons = awful.util.table.join(
        awful.button({ }, 1, awful.tag.viewonly),
        awful.button({ cfg.modkey }, 1, awful.client.movetotag)
    )

    tasklist.buttons = awful.util.table.join(awful.button({ }, 1, function (c)
                                                      -- Without this, the following
                                                      -- :isvisible() makes no sense
                                                      c.minimized = false
                                                      if not c:isvisible() then
                                                          awful.tag.viewonly(c:tags()[1])
                                                      end
                                                      -- This will also un-minimize
                                                      -- the client, if needed
                                                      client.focus = c
                                                      c:raise()
                                              end))

    for s = 1, screen.count() do

        _panels[s] = {}

        promptbox[s] = awful.widget.prompt()
        layoutbox[s] = awful.widget.layoutbox(s)
        taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons, nil, widgets.taglist.update_function)
        tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

        _panels[s].top = awful.wibox({ position = 'top', screen = s, height=32 })
        _panels[s].bottom = awful.wibox({ position = 'bottom', screen = s, height=32 })

        local left_top_layout = wibox.layout.fixed.horizontal()
        left_top_layout:add(widgets.make_widget(taglist[s]))
        left_top_layout:add(layoutbox[s])
        left_top_layout:add(promptbox[s])

        local right_top_layout = wibox.layout.fixed.horizontal()
        if s == 1 then right_top_layout:add(wibox.widget.systray()) end
        --right_top_layout:add(text_clock)
        --right_top_layout:add(kbd_switcher.widget)


        local top_layout = wibox.layout.align.horizontal()
        top_layout:set_left(left_top_layout)
        top_layout:set_right(right_top_layout)

        _panels[s].top:set_widget(top_layout)
        _panels[s].bottom:set_widget(tasklist[s])
    end

end

return panels