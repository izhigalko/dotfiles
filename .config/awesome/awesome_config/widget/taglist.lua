local awful_common = require("awful.widget.common")
local beautiful = require("beautiful")
local tag_widget = require("awesome_config.widget.tag")

local taglist = {}

function taglist.get_tag_style(tag)

    local theme = beautiful.get()

    local data = {
        focused = {
            state = false,
            bg = theme.taglist_fg_focus or theme.fg_focus,
            fg = theme.taglist_bg_focus or theme.bg_focus
        },
        urgent = {
            state = false,
            bg = theme.taglist_bg_urgent or theme.bg_urgent,
            fg = theme.taglist_fg_urgent or theme.fg_urgent
        },
        occupied = {
            state = false,
            bg = theme.taglist_bg_occupied,
            fg = theme.taglist_fg_occupied
        },
        selected = {
            state = false,
        },
        font = theme.taglist_font or theme.font or "",
        text = tag.name
    }

    local tag_clients = tag:clients()

    for i, c in ipairs(tag_clients) do
        data.focused.state = client.focus == c
        data.urgent.state = c.urgent
    end

    data.selected.state = tag.selected
    data.occupied.state = #tag_clients > 0 and not state.focused

    if data.selected.state then

        data.fg = data.focused.fg
        data.bg = data.focused.bg

    elseif data.occupied.state then

        data.fg = data.urgent.state and data.urgent.fg or data.occupied.fg
        data.bg = data.urgent.state and data.urgent.bg or data.occupied.bg

    else

        data.fg = data.focused.fg
        data.bg = data.focused.bg

    end

    return data
end

function taglist.update_function(widget, buttons, label, data, tags)

    widget:reset()
    for i, tag in ipairs(tags) do

        local cache = data[tag]
        local twidget

        if cache then
            twidget = cache
        else
            twidget = tag_widget(common.create_buttons(buttons, tag))
            data[tag] = twidget
        end

        local style = taglist.get_tag_style(tag)
        twidget.set_style(style)

        widget:add(twidget)

        if style.separator and i < #tags then

            widget:add(style.separator)

        end

    end

end

return taglist