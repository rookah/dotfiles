local tags      = {}
local statusbar = {}
local promptbox = {}
local menu		= {}
local taglist   = {}
local tasklist  = {}
local layoutbox = {}
local settings  = {}

local awful = require("awful")
awful.rules = require("awful.rules")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

-- local awesompd = require("awesompd/awesompd")
local lain = require("lain")


-- Makes sure that there's always a client that will have focus
require("awful.autofocus")

-- {{{ Error handling
-- -- Startut
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Oops, there were errors during startup!",
	text = awesome.startup_errors })
end

-- -- Runtime
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		if in_error then return end
		in_error = true
		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, an error happened!",
		text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Settings
beautiful.init(awful.util.getdir("config") .. "/lucas/theme.lua")

settings.bar_height = 16
settings.terminal = "urxvt"
settings.editor = os.getenv("EDITOR") or "vim"
settings.editor_cmd = settings.terminal .. " -e " .. settings.editor
settings.browser = "firefox"
settings.filemanager = "thunar"
settings.modkey = "Mod4"
settings.dateformat = "%Y.%m.%d %H:%M:%S"

settings.layouts =
{
	awful.layout.suit.floating,
	lain.layout.uselesstile,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		if s == 1 then
			gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		else 
			gears.wallpaper.maximized("/home/lucas/Pictures/Wallpapers/1467225965420_void2.png", s, true)
		end
	end
end
-- }}}

-- {{{ Tags
tags.settings = {
	{
		{ name = "main", props = { layout = settings.layouts[1], mwfact = .686 } },
		{ name = "dev", props = { layout = settings.layouts[2], mwfact = .686 } },
		{ name = "media", props = { layout = settings.layouts[1], mwfact = .686 } },
	},
	{
		{ name = "www", props = { layout = settings.layouts[2], mwfact = .686 } },
		{ name = "doc", props = { layout = settings.layouts[2], mwfact = .686 } },
	},
}

for s = 1, screen.count() do
	tags[s] = { }
	for i, v in ipairs(tags.settings[s]) do
		v.props.screen = s
		tags[s][i] = awful.tag.add(v.name, v.props)
	end
	tags[s][1].selected = true
end
-- }}}

-- {{{ Menu
mainmenu = awful.menu({
	items =
	{
		{ settings.browser, settings.browser, theme.menu_wbrowser },
		{ settings.filemanager, settings.filemanager, theme.menu_fbrowser },
		{ settings.terminal, settings.terminal, theme.menu_terminal },
		{ "reboot", "sudo shutdown -r now", theme.menu_reboot   },
		{ "shutdown", "sudo shutdown -h now", theme.menu_shutdown }
	}
})

-- }}}

-- {{{ Widgets

function make_fixed_textbox(w, a, t)
	local tb = wibox.widget.textbox()
	local widget = wibox.layout.margin(tb, 0, 0, -1, 0)
	widget.tb = tb
	tb.fit = function(_, _, h) return w, h end
	if a then
		tb:set_align(a)
	end
	if t then
		tb:set_markup(t)
	end
	return widget
end

padding       = wibox.widget.textbox()
separator     = wibox.widget.textbox()
cpuwidget     = make_fixed_textbox(28)
cputempwidget = make_fixed_textbox(32)
memwidget     = make_fixed_textbox(40, "center")
netdownwidget = make_fixed_textbox(42, "center")
netupwidget   = make_fixed_textbox(42, "center")
clockwidget   = make_fixed_textbox(88, "center")

padding:set_text(" ")
separator:set_markup("<span color='#444'> | </span>")

mpdicon     = wibox.widget.imagebox(beautiful.widget_mpd)
cpuicon     = wibox.widget.imagebox(beautiful.widget_cpu)
tempicon    = wibox.widget.imagebox(beautiful.widget_cputemp)
memicon     = wibox.widget.imagebox(beautiful.widget_mem)
netdownicon = wibox.widget.imagebox(beautiful.widget_net)
netupicon   = wibox.widget.imagebox(beautiful.widget_netup)
clockicon   = wibox.widget.imagebox(beautiful.widget_clock)

vicious.register(cpuwidget.tb, vicious.widgets.cpu, " $1% ", 1)
vicious.register(cputempwidget.tb, vicious.widgets.thermal, " $1℃", 1, "thermal_zone0")
vicious.register(memwidget.tb, vicious.widgets.mem, " $2mb", 1)
vicious.register(netdownwidget.tb, vicious.widgets.net, " ${enp8s0 down_mb}mb/s", 1)
vicious.register(netupwidget.tb, vicious.widgets.net, "${enp8s0 up_mb}mb/s ", 1)
-- Need a cache since there are 2 of them
vicious.cache(vicious.widgets.net)
vicious.register(clockwidget.tb, vicious.widgets.date, " " .. settings.dateformat, 1)

-- -- awesompd
-- mpd = awesompd:create({
--     scrolling = false,
--     max_width = 300,
--     path_to_icons = awful.util.getdir("config") .. "/awesompd/icons",
--     mpd_config = os.getenv("HOME") .. "/.config/mpd/mpd.conf",
--     rdecorator = "",
--     -- OSD config
--     osd = {
--         screen = screen:count(),
--         x = -10, -- 10px from right edge
--         y = settings.bar_height + 10,
--         bar_bg_color = beautiful.bg_focus,
--         bar_fg_color = "#a16a71", -- my icon color
--         alt_fg_color = "#a49c9c",
--     }
-- })
-- mpd:register_buttons({
--     { "", awesompd.MOUSE_LEFT, mpd:command_playpause() },
--     { "", awesompd.MOUSE_SCROLL_UP, mpd:command_volume_up() },
--     { "", awesompd.MOUSE_SCROLL_DOWN, mpd:command_volume_down() },
--     { "", awesompd.MOUSE_RIGHT, mpd:command_show_menu() }
-- })
-- 
-- mpdwidget = wibox.layout.margin(mpd.widget, 0, 0, -1, 0)

systray = wibox.widget.systray()

taglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ }, 3, awful.tag.viewtoggle)
)

tasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function(c)
	if c == client.focus then
		c.minimized = true
	else if not c:isvisible() then
		awful.tag.viewonly(c:tags()[1])
	end
	client.focus = c
	c:raise()
end
end),
awful.button({ }, 2, function(c)
	c:kill()
end),
awful.button({ }, 3, function()
	if instance then
		instance:hide()
		instance = nil
	else
		instance = awful.menu.clients({ theme = { width = 250 } })
	end
end),
awful.button({ }, 4, function()
	awful.client.focus.byidx(1)
	if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end)
)

for s = 1, screen:count() do
	--awful.screen.connect_for_each_screen(function(s)
	promptbox[s] = awful.widget.prompt()
	layoutbox[s] = awful.widget.layoutbox(s)
	layoutbox[s]:buttons(awful.util.table.join(
	awful.button({ }, 1, function() awful.layout.inc(settings.layouts, 1) end),
	awful.button({ }, 3, function() awful.layout.inc(settings.layouts, -1) end)
	))
	taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)
	-- to align tags on the center, tb:set_align("center") in /usr/share/awesome/lib/awful/widget/common.lua
	tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

	local left_layout  = wibox.layout.fixed.horizontal()
	local right_layout = wibox.layout.fixed.horizontal()
	statusbar[s] = awful.wibox(
	{
		position = "top",
		height = settings.bar_height,
		fg = beautiful.fg_normal,
		bg = beautiful.bg_normal,
		screen = s
	})
	left_layout:add(taglist[s])
	left_layout:add(promptbox[s])
	left_layout:add(layoutbox[s])
	if s == 1 then
		right_layout:add(padding)
		--        right_layout:add(mpdicon)
		--        right_layout:add(mpdwidget)
		right_layout:add(separator)
		right_layout:add(cpuicon)
		right_layout:add(cpuwidget)
		right_layout:add(tempicon)
		right_layout:add(cputempwidget)
		right_layout:add(separator)
		right_layout:add(memicon)
		right_layout:add(memwidget)
		right_layout:add(separator)
		right_layout:add(netdownicon)
		right_layout:add(netdownwidget)
		right_layout:add(netupwidget)
		right_layout:add(netupicon)
		right_layout:add(separator)
		right_layout:add(clockicon)
		right_layout:add(clockwidget)
		right_layout:add(separator)
		right_layout:add(systray)
	end
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(tasklist[s])
	layout:set_right(right_layout)
	statusbar[s]:set_widget(layout)
end

-- }}}

-- {{{ Mouse and Key Bindings

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () mainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ settings.modkey, }, "]", function ()
	awful.util.spawn("amixer set Master 5%+") end),
awful.key({ settings.modkey, }, "[", function ()
	awful.util.spawn("amixer set Master 5%-") end),
awful.key({ settings.modkey,	"Control"	}, "h",	function() awful.screen.focus_bydirection("left")  end),
awful.key({ settings.modkey,	"Control"	}, "l",	function() awful.screen.focus_bydirection("right") end),
awful.key({ settings.modkey,			}, "Escape", awful.tag.history.restore),

awful.key({ settings.modkey,			}, "h",              function()
	awful.client.focus.bydirection("left")
	if client.focus then client.focus:raise() end
end),
awful.key({ settings.modkey,            }, "k",              function()
	awful.client.focus.bydirection("down")
	if client.focus then client.focus:raise() end
end),
awful.key({ settings.modkey            }, "j",              function()
	awful.client.focus.bydirection("up")
	if client.focus then client.focus:raise() end
end),
awful.key({ settings.modkey            }, "l",              function()
	awful.client.focus.bydirection("right")
	if client.focus then client.focus:raise() end
end),

-- Layout manipulation
awful.key({ settings.modkey,           }, "u", awful.client.urgent.jumpto),
awful.key({ settings.modkey,           }, "Tab",
function ()
	awful.client.focus.history.previous()
	if client.focus then
		client.focus:raise()
	end
end),

-- Standard program
awful.key({ settings.modkey,           }, "Return", function () awful.util.spawn(settings.terminal) end),
awful.key({ settings.modkey, "Control" }, "r", awesome.restart),
awful.key({ settings.modkey, "Shift"   }, "q", awesome.quit),

awful.key({ settings.modkey, "Mod1" }, "h",   function() awful.tag.incmwfact(-0.025)             end),
awful.key({ settings.modkey, "Control" }, "j",   function() awful.client.incwfact(-0.125)           end),
awful.key({ settings.modkey, "Control" }, "k",   function() awful.client.incwfact(0.125)            end),
awful.key({ settings.modkey,		   }, "'",   function() awful.client.setwfact(.6975)            end),
awful.key({ settings.modkey, "Mod1" }, "l",   function() awful.tag.incmwfact(.025)            end),
awful.key({ settings.modkey, "Shift"   }, "h",   function() awful.client.swap.bydirection("left")  end),
awful.key({ settings.modkey, "Shift"   }, "k",   function() awful.client.swap.bydirection("down")  end),
awful.key({ settings.modkey, "Shift"   }, "j",   function() awful.client.swap.bydirection("up")    end),
awful.key({ settings.modkey, "Shift"   }, "l",	 function() awful.client.swap.bydirection("right") end),

awful.key({ settings.modkey,           }, "space", function () awful.layout.inc(settings.layouts,  1) end),
awful.key({ settings.modkey, "Shift"   }, "space", function () awful.layout.inc(settings.layouts, -1) end),

awful.key({ settings.modkey, "Control" }, "n", awful.client.restore),

-- Prompt
awful.key({ settings.modkey },            "r",     function () promptbox[mouse.screen]:run() end),

awful.key({ settings.modkey }, "x",
function ()
	awful.prompt.run({ prompt = "Run Lua code: " },
	promptbox[mouse.screen].widget,
	awful.util.eval, nil,
	awful.util.getdir("cache") .. "/history_eval")
end)
)

clientkeys = awful.util.table.join(
awful.key({ settings.modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
awful.key({ settings.modkey,           }, "c",      function (c) c:kill()                         end),
awful.key({ settings.modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
awful.key({ settings.modkey,           }, "o",      awful.client.movetoscreen                        ),
awful.key({ settings.modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
awful.key({ settings.modkey,           }, "n",
function (c)
	c.minimized = true
end),
awful.key({ settings.modkey,           }, "m",
function (c)
	c.maximized_horizontal = not c.maximized_horizontal
	c.maximized_vertical   = not c.maximized_vertical
end)
)

for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	-- View tag only.
	awful.key({ settings.modkey }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewonly(tag)
		end
	end),
	-- Toggle tag.
	awful.key({ settings.modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end),
	-- Move client to tag.
	awful.key({ settings.modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.movetotag(tag)
			end
		end
	end),
	-- Toggle tag.
	awful.key({ settings.modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.toggletag(tag)
			end
		end
	end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ settings.modkey }, 1, awful.mouse.client.move),
awful.button({ settings.modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = true,
			keys = clientkeys,
			buttons = clientbuttons,
			size_hints_honor = false,
		} 
	},
	{
		rule_any =
		{
			class =
			{
				"feh",
				"Gimp",
				"mpv",
				"Thunar",
				"Transmission",
			}
		},
		properties = { floating = true }
	},
	{
		rule_any =
		{
			class =
			{
				"mpv",
			}
		},
		properties = { screen = 1 }
	},
	{ rule = { class = "Firefox" }, except = { instance = "Navigator" }, properties = { floating = true } },
}
-- }}}

-- {{{ Signals

-- {{{ My under_mouse that is screen aware
local capi =
{
	screen = screen,
	mouse = mouse,
	client = client
}

local function get_area(c)
	local geometry = c:geometry()
	local border = c.border_width or 0
	geometry.width = geometry.width + 2 * border
	geometry.height = geometry.height + 2 * border
	return geometry
end

function under_mouse(c)
	local c = c or capi.client.focus
	local c_geometry = get_area(c)
	local m_coords = capi.mouse.coords()
	local screen = c.screen or awful.screen.getbycoord(geometry.x, geometry.y)
	local screen_geometry = capi.screen[screen].workarea
	return c:geometry({ x = math.max(screen_geometry.x, m_coords.x - c_geometry.width / 2),
	y = math.max(screen_geometry.y, m_coords.y - c_geometry.height / 2) })
end
-- }}}

client.connect_signal("manage", function(c)
	if not awesome.startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		awful.client.setslave(c)
		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			under_mouse(c)
			awful.placement.no_offscreen(c)
		end
		elseif not c.size_hints.user_position and not c.size_hints.program_position then
			-- Prevent clients from being unreachable after screen count change
			awful.placement.no_offscreen(c)
		end
	end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
