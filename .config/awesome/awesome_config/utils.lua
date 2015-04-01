local gears = require("gears")

local utils = { table = {}, cairo = {} }

function utils.table.merge(t1, t2)
    local ret = awful.util.table.clone(t1)

    for k, v in pairs(t2) do
        if type(v) == "table" and ret[k] and type(ret[k]) == "table" then
            ret[k] = utils.table.merge(ret[k], v)
        else
            ret[k] = v
        end
    end

    return ret
end

-- Set cairo fonts
function utils.cairo.set_font(cr, font)
    cr:set_font_size(font.size)
    cr:select_font_face(font.font, font.slant, font.face)
end

-- Get x to draw text horizontal centered
function utils.cairo.text_hcenter_coordinates(cr, text, width)
    local t_ext = cr:text_extents(text)
    return (width - t_ext.width)/2
end

return utils