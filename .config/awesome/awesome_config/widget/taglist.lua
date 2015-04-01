local awful = require("awful")
local awful_common = require("awful.widget.common")
local wibox = require("wibox")
local lain = require("lain")
local gears = require("gears")
local tag_widget = require("awesome_config.widget.tag")

local taglist = { mt = {} }

-- Get tag state
function taglist.get_tag_state(tag, index, screen_tags_count)

    local state = {
        focused = false,
        urgent = false,
        occupies = false,
        selected = false,
        text = tag.name,
        is_first = index == 1,
        is_last = index == screen_tags_count
    }

    local tag_clients = tag:clients()

    for i, c in ipairs(tag_clients) do
        state.focused = client.focus == c
        state.urgent = c.urgent
    end

    state.selected = tag.selected
    state.occupied = #tag_clients > 0 and not state.focused

    return state
end

-- Custom taglist based on awful.widget.taglist
function taglist.new(screen, filter, buttons)

    local margin = wibox.layout.margin()
    local layout = wibox.layout.fixed.horizontal()
    local data = setmetatable({}, { __mode = 'k' })

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

--                if state.separator and i < #tags then
--                    layout:add(state.separator)
--                end
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
    margin:set_widget(layout)
    margin:set_top(1)
    margin:set_bottom(1)
    margin:set_left(3)
    margin:set_right(3)

    return margin
end

function taglist.mt:__call(...)
    return taglist.new(...)
end

return setmetatable(taglist, taglist.mt)