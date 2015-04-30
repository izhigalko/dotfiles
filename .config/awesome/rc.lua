local gears = require('gears')
local awful = require('awful')
awful.rules = require('awful.rules')
require('awful.autofocus')

local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')
local menubar = require('menubar')
local tyrannical = require('tyrannical')
local cyclefocus = require('cyclefocus')
local lain = require('lain')

local config = {
    modkey = 'Mod4',
    terminal = 'termite',
    keyboard_layouts = {{'us', '', 'EN'}, {'ru,us', '', 'RU'}},
    home_dir = os.getenv('HOME')
}

-- Tags settings

tyrannical.tags = {
    {
        name = 'Term',
        init = true,
        exclusive = true,
        selected = true,
        force_screen = true,
        screen = 1,
        layout = lain.layout.uselessfair,
        class = {'urxvt', 'URxvt', 'termite', 'Termite'}
    },
    {
        name = 'IM0',
        init = true,
        exclusive = true,
        force_screen = true,
        screen = 1,
        layout = awful.layout.suit.tile.bottom,
        class = {'viber', 'Viber', 'skype', 'Skype', 'ViberPC'}
    },
    {
        name = 'IM1',
        init = true,
        exclusive = true,
        force_screen = true,
        screen = 1,
        layout = awful.layout.suit.tile.bottom,
        class = {'hexchat', 'HexChat', 'pidgin', 'Pidgin'}
    },
    {
        name = 'Sys',
        init = true,
        locked = true,
        force_screen = true,
        layout = awful.layout.suit.max
    },
    {
        name = 'Virt',
        init = true,
        exclusive = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max,
        class = {'VirtualBox'}
    },
    {
        name = 'Dev0',
        init = true,
        exclusive = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max,
        class = {'jetbrains-pycharm'}
    },
    {
        name = 'Dev1',
        init = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max
    },
    {
        name = 'WWW',
        init = true,
        exclusive = true,
        selected = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1,
        layout = awful.layout.suit.max,
        class = {'Chromium'}
    },
    {
        name = 'Fall',
        init = false,
        fallback = true,
        force_screen = true,
        screen = screen.count() > 1 and 2 or 1
    }
}

tyrannical.settings.block_children_focus_stealing = true --Block popups ()
tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client
tyrannical.properties.size_hints_honor = { xterm = false, URxvt = false, aterm = false, sauer_client = false, mythfrontend  = false}

-- /Tags settings

-- Notification

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = 'Oops, there were errors during startup!',
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal('debug::error', function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = 'Oops, an error happened!',
                         text = err })
        in_error = false
    end)
end

-- /Notification

-- Widgets

-- {{{ Clock

text_clock = awful.widget.textclock()

-- }}}

-- {{{ Keyboard layout switcher

kbd_switcher = {}
kbd_switcher.layouts = {[0] = 'En', [1] = 'Ru'}
kbd_switcher.widget = wibox.widget.textbox()
function kbd_switcher.set_text(layout)
    local layout_text = kbd_switcher.layouts[layout]
    kbd_switcher.widget:set_text(' ' .. layout_text .. ' ')   
end
kbd_switcher.set_text(0)

dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    kbd_switcher.set_text(data[2])
end)

-- }}}

-- /Widgets

-- Load theme

beautiful.init(config.home_dir .. '/.config/awesome/theme.lua')

for s = 1, screen.count() do
    gears.wallpaper.maximized(config.home_dir .. '/.config/awesome/wallpapers/1.jpg', s, true)
end

-- /Load theme

-- Panels

local promptbox = {}
local layoutbox = {}
local taglist = {}
local tasklist = {}

taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ config.modkey }, 1, awful.client.movetotag)
)

tasklist.buttons = awful.util.table.join(awful.button({ }, 1, function (c)
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                          end))

panels = {}

for s = 1, screen.count() do

    panels[s] = {}
    promptbox[s] = awful.widget.prompt()
    layoutbox[s] = awful.widget.layoutbox(s)
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)
    tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

    panels[s].top = awful.wibox({ position = 'top', screen = s })
    panels[s].bottom = awful.wibox({ position = 'bottom', screen = s })

    local left_top_layout = wibox.layout.fixed.horizontal()
    left_top_layout:add(taglist[s])
    left_top_layout:add(layoutbox[s])
    left_top_layout:add(promptbox[s])

    local right_top_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_top_layout:add(wibox.widget.systray()) end
    right_top_layout:add(text_clock)
    right_top_layout:add(kbd_switcher.widget)


    local top_layout = wibox.layout.align.horizontal()
    top_layout:set_left(left_top_layout)
    top_layout:set_right(right_top_layout)

    panels[s].top:set_widget(top_layout)
    panels[s].bottom:set_widget(tasklist[s])
end

-- /Panels

-- Keys

globalkeys = awful.util.table.join(
    awful.key({ config.modkey, }, 'Tab', function(c) cyclefocus.cycle(1, {modifier='Super_L'}) end),
    awful.key({ config.modkey, 'Shift' }, 'Tab', function(c) awful.screen.focus_relative(1) end),
    
    awful.key({ config.modkey, }, 'Left', awful.tag.viewprev),
    awful.key({ config.modkey, }, 'Right', awful.tag.viewnext),

    awful.key({ config.modkey, }, 'e', awful.client.urgent.jumpto),

    awful.key({ config.modkey, }, 'Return', function () awful.util.spawn(config.terminal) end),
    
    awful.key({ config.modkey }, 'r', function () promptbox[mouse.screen]:run() end),
    
    awful.key({ config.modkey, 'Control' }, 'l', function () awful.util.spawn('xscreensaver-command --lock') end)
    
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ config.modkey }, '#' .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ config.modkey, 'Control' }, '#' .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ config.modkey, 'Shift' }, '#' .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ config.modkey, 'Control', 'Shift' }, '#' .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientkeys = awful.util.table.join(
    awful.key({ config.modkey, }, 'f', function (c) c.fullscreen = not c.fullscreen end),
    awful.key({ config.modkey, 'Shift' }, 'c',      function (c) c:kill()  end),
    awful.key({ config.modkey, }, 'o', awful.client.movetoscreen),
    awful.key({ config.modkey, }, 'm',
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ config.modkey }, 1, awful.mouse.client.move),
    awful.button({ config.modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons
        }
    }
 --,
 --   {
 --       rule = {
 --           class = {'URxvt', 'Termite', 'urxvt', 'termite'}
 --       },
 --       properties = {
 --           opacity = 1
 --       }
 --   }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function (c, startup)
    -- Enable sloppy focus
    c:connect_signal('mouse::enter', function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == 'normal' or c.type == 'dialog') then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align('center')
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

--client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- /Keys
