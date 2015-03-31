local wibox = require("wibox")
local gears = require("gears")

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

function tag:draw(widget, wibox, cr, width, height)

    local fg, bg

    cr:set_source(gears.color(self.style.fg))
	cr:select_font_face(self.style.font)
	local ext = cr:text_extents(text)
	cr:move_to(coord[1] - (ext.width/2 + width/2), 40 - (ext.height/2 + ext.y_bearing))
	cr:show_text(text)

--    if self.style.selected.state then
--
--        nil
--
--    end if

end

function tag:new(style)

    local ret = wibox.widget.base.make_widget()

    for k, v in pairs(margin) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    ret:set_style(style)

end

function tag.mt:__call(...)
	return redtag.new(...)
end

return setmetatable(tag, tag.mt)