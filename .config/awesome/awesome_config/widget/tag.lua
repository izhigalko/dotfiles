local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local lgi = require("lgi")
local Pango = lgi.Pango
local PangoCairo = lgi.PangoCairo

local utils = require("awesome_config.utils")


local tag = {
    mt = {},
    default_style = {
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
}

function tag:set_state(state)
    self.state = state
    self._emit_updated()
end

function tag:set_style(style)
    self.style = style
    self._emit_updated()
end

function tag:fit(width, height)
    if self.style.width then
        return math.min(width, self.style.width), height
    else
        return width, height
    end
end

function tag:draw_text(cr, text, width, height)
    cr:update_layout(self._text_layout)
    self._text_layout:set_alignment("CENTER")
    self._text_layout:set_wrap("WORD_CHAR")
    self._text_layout:set_font_description(beautiful.get_font())
    self._text_layout.text = text
    self._text_layout.attributes = nil
    self._text_layout.width = Pango.units_from_double(width)
    self._text_layout.height = Pango.units_from_double(height)
    local ink, logical = self._text_layout:get_pixel_extents()
    local y = (height - logical.height) / 2
    cr:move_to(0, y)
    cr:show_layout(self._text_layout)
    return logical
end

function tag:draw(wibox, cr, width, height)
    local t_ext, text_x, text_y, x, y, w, h

    -- Fill background
    cr:save()

    cr:set_source(gears.color(self.style.background_color))
    cr:rectangle(0, 0, width, height)
    cr:fill()

    cr:restore()

    -- Draw left separator
    cr:save()
    cr:set_source(gears.color(self.style.mark_color))
    cr.line_width = 1

    if not self.state.is_first then
        cr:move_to(0, 3)
        cr:line_to(0, height - 3)
        cr:stroke()
    end

    -- Draw right separator

    if not self.state.is_last then
        cr:move_to(width, 3)
        cr:line_to(width, height - 3)
        cr:stroke()
    end

    cr:restore()

    -- Set text
    cr:save()

    cr:set_source(gears.color(self.state.urgent and self.style.urgent.color or self.style.font_color))
    local logical = self:draw_text(cr, self.state.text, width, height)

    cr:restore()

    -- Draw selected mark
    if self.state.selected then
        cr:save()

        cr:set_source(gears.color(self.style.selected.color))
        cr.line_width = 1
        cr:move_to(logical.x - logical.x/2, logical.height + 5)
        cr:line_to(logical.x + logical.x/2 + logical.width, logical.height + 5)
        cr:stroke()

        cr:restore()
    end

    -- Draw occupied mark
    cr:save()

    cr:set_source(gears.color(self.style.mark_color))
    cr:rectangle(5, 5, 5, 5)
    if self.state.occupied then
        cr:fill()
    else
        cr.line_width = 1
        cr:stroke()
    end

    cr:restore()

end

local function new(state)
    local ret = wibox.widget.base.make_widget()
    local style = beautiful.tag and utils.table.merge(tag.default_style, beautiful.tag) or tag.default_style

    for k, v in pairs(tag) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    ret:set_style(style)
    ret:set_state(state)
    local ctx = PangoCairo.font_map_get_default():create_context()
    ret._text_layout = Pango.Layout.new(ctx)

    return ret
end

function tag.mt:__call(...)
	return new(...)
end

return setmetatable(tag, tag.mt)