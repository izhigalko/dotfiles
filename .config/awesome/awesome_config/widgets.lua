local widgets = {}

local wibox = require('wibox')
local common = require('awful.widget.common')
local beautiful = require("beautiful")

widgets.taglist = {}

-- taglist update function with separator (Copied from original code)
function widgets.taglist.update_function(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()

    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, m, l, s
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            m  = cache.m
            s = cache.s
        else
            ib = wibox.widget.imagebox()
            tb = wibox.widget.textbox()
            bgb = wibox.widget.background()
            m = wibox.layout.margin(tb, 4, 4, 4, 4)
            l = wibox.layout.fixed.horizontal()
            s = i < #objects and wibox.layout.margin(wibox.widget.textbox('|'), 4, 4, 4, 4) or nil

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ib)
            l:add(m)

            if s ~= nil then
                l:add(s)
            end

            -- And all of this gets a background
            bgb:set_widget(l)

            bgb:buttons(common.create_buttons(buttons, o))

            data[o] = {
                ib = ib,
                tb = tb,
                bgb = bgb,
                m   = m,
                s = s
            }
        end

        local text, bg, bg_image, icon = label(o)
        -- The text might be invalid, so use pcall
        if not pcall(tb.set_markup, tb, text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        end
        bgb:set_bg(bg)
        if type(bg_image) == "function" then
            bg_image = bg_image(tb,o,m,objects,i)
        end
        bgb:set_bgimage(bg_image)
        ib:set_image(icon)
        w:add(bgb)
    end
end

-- Widget with margin and background
function widgets.make_widget(origin)
    local theme = beautiful.get()

    local widget_margin = theme.widget_margin or 5
    local widget_background = theme.widget_bg or nil

    local w = wibox.layout.margin(origin)
    w:set_margins(widget_margin)
    w = widget_background and wibox.widget.background(w, widget_background) or w

    return w
end

return widgets