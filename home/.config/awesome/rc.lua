pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

-- {{{ Variable definitions

local modkey = "Mod4"
local altkey = "Mod1"
local terminal = "alacritty"
local vi_focus = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local editor = os.getenv("EDITOR") or "vim"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "x" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating
}

awful.util.taglist_buttons =
    mytable.join(
        awful.button(
            {},
            1,
            function(t)
                t:view_only()
            end
        ),
        awful.button(
            { modkey },
            1,
            function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end
        ),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button(
            { modkey },
            3,
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),
        awful.button(
            {},
            4,
            function(t)
                awful.tag.viewnext(t.screen)
            end
        ),
        awful.button(
            {},
            5,
            function(t)
                awful.tag.viewprev(t.screen)
            end
        )
    )

awful.util.tasklist_buttons =
    mytable.join(
        awful.button(
            {},
            1,
            function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", { raise = true })
                end
            end
        ),
        awful.button(
            {},
            3,
            function()
                awful.menu.client_list({ theme = { width = 250 } })
            end
        ),
        awful.button(
            {},
            4,
            function()
                awful.client.focus.byidx(1)
            end
        ),
        awful.button(
            {},
            5,
            function()
                awful.client.focus.byidx(-1)
            end
        )
    )


-- }}}

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "x"))

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal(
    "property::geometry",
    function(s)
        -- Wallpaper
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal(
    "arrange",
    function(s)
        local only_one = #s.tiled_clients == 1
        for _, c in pairs(s.clients) do
            if only_one and not c.floating or c.maximized or c.fullscreen then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end
        end
    end
)

-- }}}

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- {{{ Mouse bindings

root.buttons(mytable.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))

-- }}}

-- {{{ Key bindings
-- bindsym XF86AudioMute exec amixer sset Master toggle && killall -USR1 i3blocks
globalkeys =
    gears.table.join(
        awful.key(
            { modkey },
            "XF86AudioRaiseVolume",
            function()
                awful.util.spawn("pulsemixer --change-volume +1")
            end,
            { description = "Volumn Up", group = "awesome" }
        ),
        awful.key(
            { modkey },
            "XF86AudioLowerVolume",
            function()
                awful.util.spawn("pulsemixer --change-volume -1")
            end,
            { description = "Volumn Down", group = "awesome" }
        ),
        awful.key(
            {},
            "XF86AudioRaiseVolume",
            function()
                awful.util.spawn("pulsemixer --change-volume +5")
            end,
            { description = "Volumn Up", group = "awesome" }
        ),
        awful.key(
            {},
            "XF86AudioLowerVolume",
            function()
                awful.util.spawn("pulsemixer --change-volume -5")
            end,
            { description = "Volumn Down", group = "awesome" }
        ),
        awful.key(
            {},
            "XF86AudioMute",
            function()
                awful.util.spawn("pulsemixer --toggle-mute")
            end,
            { description = "Volumn Mute", group = "awesome" }
        ),
        awful.key({ modkey, "Shift" }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
        awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
        awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
        awful.key(
            { modkey },
            "[",
            function()
                -- tag_view_nonempty(-1)
                local focused = awful.screen.focused()
                for i = 1, #focused.tags do
                    awful.tag.viewidx(-1, focused)
                    if #focused.clients > 0 then
                        return
                    end
                end
            end,
            { description = "view previous non-empty tag", group = "tag" }
        ),
        awful.key(
            { modkey },
            "]",
            function()
                -- tag_view_nonempty(1)
                local focused = awful.screen.focused()
                for i = 1, #focused.tags do
                    awful.tag.viewidx(1, focused)
                    if #focused.clients > 0 then
                        return
                    end
                end
            end,
            { description = "view next non-empty tag", group = "tag" }
        ),
        awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
        awful.key(
            { modkey },
            "j",
            function()
                awful.client.focus.byidx(1)
            end,
            { description = "focus next by index", group = "client" }
        ),
        awful.key(
            { modkey },
            "k",
            function()
                awful.client.focus.byidx(-1)
            end,
            { description = "focus previous by index", group = "client" }
        ),
        -- Layout manipulation
        awful.key(
            { modkey, "Shift" },
            "j",
            function()
                awful.client.swap.byidx(1)
            end,
            { description = "swap with next client by index", group = "client" }
        ),
        awful.key(
            { modkey, "Shift" },
            "k",
            function()
                awful.client.swap.byidx(-1)
            end,
            { description = "swap with previous client by index", group = "client" }
        ),
        awful.key(
            { modkey, "Control" },
            "j",
            function()
                awful.screen.focus_relative(1)
            end,
            { description = "focus the next screen", group = "screen" }
        ),
        awful.key(
            { modkey, "Control" },
            "k",
            function()
                awful.screen.focus_relative(-1)
            end,
            { description = "focus the previous screen", group = "screen" }
        ),
        awful.key(
            { modkey },
            "Tab",
            function()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            { description = "go back", group = "client" }
        ),
        -- Standard program
        awful.key(
            { modkey },
            "Return",
            function()
                awful.spawn(terminal)
            end,
            { description = "open a terminal", group = "launcher" }
        ),
        awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
        awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
        awful.key(
            { modkey },
            "l",
            function()
                awful.tag.incmwfact(0.05)
            end,
            { description = "increase master width factor", group = "layout" }
        ),
        awful.key(
            { modkey },
            "h",
            function()
                awful.tag.incmwfact(-0.05)
            end,
            { description = "decrease master width factor", group = "layout" }
        ),
        awful.key(
            { modkey, "Shift" },
            "h",
            function()
                awful.tag.incnmaster(1, nil, true)
            end,
            { description = "increase the number of master clients", group = "layout" }
        ),
        awful.key(
            { modkey, "Shift" },
            "l",
            function()
                awful.tag.incnmaster(-1, nil, true)
            end,
            { description = "decrease the number of master clients", group = "layout" }
        ),
        awful.key(
            { modkey, "Control" },
            "h",
            function()
                awful.tag.incncol(1, nil, true)
            end,
            { description = "increase the number of columns", group = "layout" }
        ),
        awful.key(
            { modkey, "Control" },
            "l",
            function()
                awful.tag.incncol(-1, nil, true)
            end,
            { description = "decrease the number of columns", group = "layout" }
        ),
        awful.key(
            { modkey },
            "space",
            function()
                awful.layout.inc(1)
            end,
            { description = "select next", group = "layout" }
        ),
        awful.key(
            { modkey, "Shift" },
            "space",
            function()
                awful.layout.inc(-1)
            end,
            { description = "select previous", group = "layout" }
        ),
        awful.key(
            { modkey, "Shift" },
            "n",
            function()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    c:emit_signal("request::activate", "key.unminimize", { raise = true })
                end
            end,
            { description = "restore minimized", group = "client" }
        ),
        -- Prompt
        awful.key(
            { modkey },
            "r",
            function()
                awful.screen.focused().mypromptbox:run()
            end,
            { description = "run prompt", group = "launcher" }
        ),
        awful.key(
            { modkey },
            "x",
            function()
                awful.prompt.run {
                    prompt = "Run Lua code: ",
                    textbox = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            { description = "lua execute prompt", group = "awesome" }
        ),
        awful.key(
            { modkey },
            "e",
            function()
                awful.util.spawn(awful.util.terminal .. " --class fm -e nnn -de")
            end,
            { description = "Files", group = "launcher" }
        ),
        awful.key(
            { modkey },
            "p",
            function()
                awful.util.spawn(awful.util.terminal .. " --class pulsemixer -e pulsemixer")
            end,
            { description = "Audio", group = "launcher" }
        ),
        awful.key(
            { modkey },
            "s",
            function()
                awful.util.spawn("rofi -show window")
            end,
            { description = "switch windows", group = "launcher" }
        ),
        -- Menubar
        awful.key(
            { modkey },
            "d",
            function()
                awful.util.spawn("rofi -show drun")
            end,
            { description = "show the menubar", group = "awesome" }
        ),
        awful.key(
            { modkey },
            "z",
            function()
                awful.screen.focused().mywibox.visible = not awful.screen.focused().mywibox.visible
            end,
            { description = "toggle wibar", group = "awesome" }
        )
    )

clientkeys =
    gears.table.join(
        awful.key(
            { modkey },
            "f",
            awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }
        ),
        awful.key(
            { modkey },
            "w",
            function(c)
                c:kill()
            end,
            { description = "close", group = "client" }
        ),
        awful.key(
            { modkey, "Control" },
            "space",
            awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }
        ),
        awful.key(
            { modkey },
            "a",
            function(c)
                c:swap(awful.client.getmaster())
            end,
            { description = "move to master", group = "client" }
        ),
        awful.key(
            { modkey },
            "n",
            function(c)
                c.minimized = true
            end,
            { description = "minimize", group = "client" }
        ),
        awful.key(
            { modkey },
            "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }
        ),
        awful.key(
            { modkey, "Shift" },
            "m",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }
        )
    )

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys =
        gears.table.join(
            globalkeys,
            -- View tag only.
            awful.key(
                { modkey },
                "#" .. i + 9,
                function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        tag:view_only()
                    end
                end,
                { description = "view tag #" .. i, group = "tag" }
            ),
            -- Toggle tag display.
            awful.key(
                { modkey, "Control" },
                "#" .. i + 9,
                function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        awful.tag.viewtoggle(tag)
                    end
                end,
                { description = "toggle tag #" .. i, group = "tag" }
            ),
            -- Move client to tag.
            awful.key(
                { modkey, "Shift" },
                "#" .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                    end
                end,
                { description = "move focused client to tag #" .. i, group = "tag" }
            ),
            -- Toggle tag on focused client.
            awful.key(
                { modkey, "Control", "Shift" },
                "#" .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end,
                { description = "toggle focused client on tag #" .. i, group = "tag" }
            )
        )
end

clientbuttons =
    gears.table.join(
        awful.button(
            {},
            1,
            function(c)
                c:emit_signal("request::activate", "mouse_click", { raise = true })
            end
        ),
        awful.button(
            { modkey },
            1,
            function(c)
                c:emit_signal("request::activate", "mouse_click", { raise = true })
                awful.mouse.client.move(c)
            end
        ),
        awful.button(
            { modkey },
            3,
            function(c)
                c:emit_signal("request::activate", "mouse_click", { raise = true })
                awful.mouse.client.resize(c)
            end
        )
    )

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            --callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false,
            maximized = false
        }
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry"
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "launcher",
                "pulsemixer"
            },
            name = {
                "Event Tester", -- xev.
                "新建任务面板"
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up"         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = false }
    },
    {
        rule = { class = "Emacs" },
        properties = { screen = 1, tag = "7", switchtotag = true }
    },
    {
        rule = { class = "Alacritty" },
        properties = { screen = 1, tag = "1", switchtotag = true }
    },
    {
        rule = { class = "Microsoft-edge" },
        properties = { screen = 1, tag = "2", switchtotag = true }
    },
    {
        rule = { class = "firefox" },
        properties = { screen = 1, tag = "2", switchtotag = true }
    },
    {
        rule = { class = "fm" },
        properties = { screen = 1, tag = "3", switchtotag = true }
    },
    {
        rule = { class = "pcmanfm" },
        properties = { screen = 1, tag = "3", switchtotag = true }
    },
    {
        rule = { class = "steam" },
        properties = { screen = 1, tag = "8", switchtotag = true }
    },
    {
        rule = { class = "dota2" },
        properties = { screen = 1, tag = "8", switchtotag = true }
    },
    {
        rule = { class = "wechat.exe" },
        properties = { screen = 1, tag = "x", switchtotag = true }
    },
    {
        rule = { class = "QQ" },
        properties = { screen = 1, tag = "x", switchtotag = true }
    }
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
    end
)

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}

-- Autorun programs
awful.spawn.with_shell(os.getenv("HOME") .. "/.config/autostart/autostart.sh")
