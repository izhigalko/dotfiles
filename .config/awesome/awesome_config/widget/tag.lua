local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local utils = require("awesome_config.utils")


local tag = {
    mt = {},
    default_style = {
        width = 60,
        font = { font = "Sans", size = 10, face = 0, slant = 0 },
        color = "#FFFFFF",
        background = "#332F2E",
        text_x_gap = 10
    }
}

function tag:set_state(state)
    self.state = state
    self._emit_updated()
end

function tag:set_style(style)
    self.style = style
end

function tag:fit(width, height)
    if self.style.width then
        return math.min(width, self.style.width), height
    else
        return width, height
    end
end

function tag:draw(wibox, cr, width, height)
    local t_ext, text_x, text_y, x, y, w, h

    -- Fill background
    cr:save()
    cr:set_source(gears.color(self.style.background))

    -- Draw arrow background
    cr:move_to(0, 0)

    if self.state.is_first then
        cr:line_to(height/2, height/2)
    end

    cr:line_to(0, height)

    if self.state.is_last then
        cr:line_to(width - height/2, height)
        cr:line_to(width, height/2)
        cr:line_to(width - height/2, 0)
    else
        cr:line_to(width, height)
        cr:line_to(width, 0)
    end

    cr:line_to(0, 0)

    cr:fill()
    cr:restore()

    -- Draw arrow borders
    cr:save()
    cr:set_source(gears.color(self.style.color))
    cr.line_width = 0.5
    cr:set_dash({ 0.1 }, 0.1, 0);

    cr:move_to(width - height/2, height)
    cr:line_to(width, height/2)
    cr:line_to(width - height/2, 0)

    cr:stroke()

    if self.state.is_first then
        cr:move_to(0, 0)
        cr:line_to(height/2, height/2)
        cr:line_to(0, height)
    end

    cr:stroke()
    cr:restore()

    -- Set text
    cr:save()

    cr:set_source(gears.color(self.style.color))
    utils.cairo.set_font(cr, self.style.font)

    -- if is first tag we need to change x coordinate
    t_ext = cr:text_extents(self.state.text)
    text_x, text_y = (width - height/2 - t_ext.width)/2, (height*2.5)/4
    text_x = self.state.is_first and text_x + height/4 or text_x

	cr:move_to(text_x, text_y)
	cr:show_text(self.state.text)

    cr:restore()

    -- Draw selected mark
    if self.state.selected then
        cr:save()

        x, y = text_x, height - (height - text_y)/2
        cr:set_source(gears.color(self.style.color))
        cr.line_width = 1
        cr:move_to(x - 5, y)
        cr:line_to(x + t_ext.x_advance + 5, y)
        cr:stroke()

        cr:restore()
    end
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