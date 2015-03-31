local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lgi = require("lgi")
local Pango = lgi.Pango
local PangoCairo = lgi.PangoCairo

local tag = {
    mt = {},
}

function tag:set_style(style)
    self.style = style
    self._emit_updated()
end

function tag:draw_selected()

end

function tag:draw_focused()
end

function tag:draw_occupied()
end

function tag:draw_urgent()
end

function tag:fit(width, height)
   local size = math.min(width, height)
   return 100, 100
end

function tag:draw(widget, wibox, cr, width, height)
    naughty.notify({ preset = naughty.config.presets.critical, title = "debug", text = width })
    cr:set_source(gears.color.parse_color("#FFFFFF"))
    cr:move_to(0, 0)
    cr:line_to(width, height)
    cr:move_to(width, 0)
    cr:line_to(0, height)
    cr:set_line_width(3)
    cr:stroke()
--    local ctx = PangoCairo.font_map_get_default():create_context()
--    local layout = Pango.Layout.new(ctx)
--    layout:set_ellipsize("END")
--    layout:set_wrap("WORD")
--    layout:set_alignment("CENTER")
--    layout:set_font_description(beautiful.get_font())
--    layout.text = self.style.text
--    layout.attributes = nil
--    naughty.notify({ preset = naughty.config.presets.critical, title = "debug", text = self.style.text })
--    cr:update_layout(layout)
--    layout.width = Pango.units_from_double(width)
--    layout.height = Pango.units_from_double(height)
--    local ink, logical = layout:get_pixel_extents()
--    local offset = (height - logical.height) / 2
--    cr:move_to(0, offset)
--    cr:show_layout(layout)
end

function tag:new(style)

    local ret = wibox.widget.base.make_widget()

    for k, v in pairs(tag) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    ret:set_style(style)

    return ret
end

function tag.mt:__call(...)
	return tag.new(...)
end

return setmetatable(tag, tag.mt)