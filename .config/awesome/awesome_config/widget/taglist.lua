local awful = require("awful")
local awful_common = require("awful.widget.common")
local beautiful = require("beautiful")
local wibox = require("wibox")
local tag_widget = require("awesome_config.widget.tag")

local taglist = { mt = {} }

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

    -- TODO: rewrite tag widget style

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

    data.fg = '#FFFFFF'
    data.bg = '#000000'

    return data
end

function taglist.new(screen, filter, buttons)

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

                local cache = data[tag]
                local twidget

                if cache then
                    twidget = cache
                else
                    twidget = tag_widget(awful_common.create_buttons(buttons, tag))
                    data[tag] = twidget
                end

                local style = taglist.get_tag_style(tag)
                twidget:set_style(style)

                layout:add(twidget)

                if style.separator and i < #tags then
                    layout:add(style.separator)
                end
            end
        end
    end
    local uc = function (c) return update(c.screen) end
    local ut = function (t) return update(awful.tag.getscreen(t)) end

    local client_signals = {
        "focus", "unfocus", "property::urgent", "tagged", "untagged", "unmanage"
    }

    local tags_signals = {
        "property::selected", "property::icon", "property::hide", "property::name", "property::activated",
        "property::screen", "property::index"
    }

    for i, signal in ipairs(client_signals) do
        client.connect_signal(signal, uc)
    end

    for i, signal in ipairs(tags_signals) do
        awful.tag.attached_connect_signal(screen, signal, ut)
    end

    client.connect_signal("property::screen", function(c)
        update(screen)
    end)

    update(screen)

    return layout
end

function taglist.mt:__call(...)
    return taglist.new(...)
end

return setmetatable(taglist, taglist.mt)