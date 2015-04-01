local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local utils = require("awesome_config.utils")


local tag = {
    mt = {},
    default_style = {
        width = 100,
        font = { font = "Sans", size = 15, face = 0, slant = 0 },
        fg_color = "#ffffff",
        bg_color = "#000000",
        border_color = "#111111"
    }
}

function tag:set_state(state)
    self.state = state
    self._emit_updated()
end

function tag:set_style(style)
    self.style = style
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
    if self.style.width then
        return math.min(width, self.style.width), height
    else
        return width, height
    end
end

function tag:draw(wibox, cr, width, height)
    cr:set_source(gears.color(self.style.bg_color))
    utils.cairo.draw_left_arrow(cr, width, height)
    cr:set_source(gears.color(self.style.fg_color))
    utils.cairo.set_font(cr, self.style.font)
    local x, y = utils.cairo.text_hcenter_coordinates(cr, self.state.text, width), (height*2.5)/4
	cr:move_to(x, y)
	cr:show_text(self.state.text)
end

local function new(state)
    local ret = wibox.widget.base.make_widget()

    for k, v in pairs(tag) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    ret:set_style(tag.default_style)
    ret:set_state(state)

    return ret
end

function tag.mt:__call(...)
	return new(...)
end

return setmetatable(tag, tag.mt)