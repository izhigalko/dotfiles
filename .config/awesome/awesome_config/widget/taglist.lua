local awful = require("awful")
local awful_common = require("awful.widget.common")
local wibox = require("wibox")
local beautiful = require("beautiful")

local utils = require("awesome_config.utils")
local tag_widget = require("awesome_config.widget.tag")

local taglist = {
    mt = {},
    default_style = {
        margins = {5, 5, 5, 5}
    }
}

-- Get tag state
function taglist.get_tag_state(tag, index, screen_tags_count)

    local state = {
        focused = false,
        urgent = false,
        occupies = false,
        selected = false,
        text = string.upper(tag.name),
        is_first = index == 1,
        is_last = index == screen_tags_count
    }

    local tag_clients = tag:clients()

    for i, c in ipairs(tag_clients) do
        state.focused = client.focus == c
        state.urgent = c.urgent
    end

    state.selected = tag.selected
    state.occupied = #tag_clients > 0

    return state
end

-- Custom taglist based on awful.widget.taglist
function taglist.new(screen, filter, buttons, style)

    local layout = wibox.layout.fixed.horizontal()
    local data = setmetatable({}, { __mode = 'k' })
    local style = beautiful.tag and utils.table.merge(taglist.default_style, beautiful.taglist) or taglist.default_style

    local tag_filter = function(screen, filter)
        local tags = {}
        for i, tag in ipairs(awful.tag.gettags(screen)) do
            if not awful.tag.getproperty(tag, "hide") and filter(t) then
                table.insert(tags, tag)
            end
        end
        return tags
    end

    local update = function (s)
        if s == screen then
            local tags = tag_filter(s, filter)

            layout:reset()
            for i, tag in ipairs(tags) do
                local cache, twidget, sep = data[tag], nil, nil
                local state = taglist.get_tag_state(tag, i, #tags)

                if cache then
                    twidget = cache
                    twidget:set_state(state)
                else
                    twidget = tag_widget(state)
                    twidget:buttons(awful_common.create_buttons(buttons, tag))
                    data[tag] = twidget
                end

                layout:add(twidget)
            end
        end
    end

    local client_updated = function (client) return update(client.screen) end
    local tag_updated = function (tag) return update(awful.tag.getscreen(tag)) end

    -- Client signals
    client.connect_signal("focus", client_updated)
    client.connect_signal("unfocus", client_updated)
    client.connect_signal("property::urgent", client_updated)
    client.connect_signal("tagged", client_updated)
    client.connect_signal("untagged", client_updated)
    client.connect_signal("unmanage", client_updated)
    -- Client change screen signal
    client.connect_signal("property::screen", function(c) update(screen) end)

    -- Tag signals
    awful.tag.attached_connect_signal(screen, "property::selected", tag_updated)
    awful.tag.attached_connect_signal(screen, "property::icon", tag_updated)
    awful.tag.attached_connect_signal(screen, "property::hide", tag_updated)
    awful.tag.attached_connect_signal(screen, "property::name", tag_updated)
    awful.tag.attached_connect_signal(screen, "property::activated", tag_updated)
    awful.tag.attached_connect_signal(screen, "property::screen", tag_updated)
    awful.tag.attached_connect_signal(screen, "property::index", tag_updated)

    update(screen)

    local margin = wibox.layout.margin(layout, table.unpack(style.margins))

    return margin
end

function taglist.mt:__call(...)
    return taglist.new(...)
end

return setmetatable(taglist, taglist.mt)