local tags      = {}
local menu	    = {}
local layoutbox = {}
local settings  = {}

local awful = require("awful")
awful.rules = require("awful.rules")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

local hotkeys_popup = require("awful.hotkeys_popup").widget

local awesompd = require("awesompd/awesompd")


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
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, an error happened!",
    text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- {{{ Settings
beautiful.init(awful.util.getdir("config") .. "/roukah/theme.lua")

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
  awful.layout.suit.tile
}

-- }}}

-- {{{ Wallpaper
local function set_wallpaper(s)
  if beautiful.wallpaper then
    if s.index == 1 then
      --gears.wallpaper.maximized(beautiful.wallpaper, s, true)
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    else 
      gears.wallpaper.maximized(beautiful.void_wallpaper, s, true)
    end
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


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


-- {{{ Wibar

local taglist_buttons = awful.util.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
  if client.focus then
    client.focus:toggle_tag(t)
  end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)
local tasklist_buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
  if c == client.focus then
    c.minimized = true
  else
    -- Without this, the following
    -- :isvisible() makes no sense
    c.minimized = false
    if not c:isvisible() and c.first_tag then
      c.first_tag:view_only()
    end
    -- This will also un-minimize
    -- the client, if needed
    client.focus = c
    c:raise()
  end
end),
awful.button({ }, 2, function (c)
  c:kill()
end),
awful.button({ }, 4, function ()
  awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
  awful.client.focus.byidx(-1)
end))


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
cputempwidget = make_fixed_textbox(21)
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
vicious.register(cputempwidget.tb, vicious.widgets.thermal, " $1°", 1, "thermal_zone0")
vicious.register(memwidget.tb, vicious.widgets.mem, " $2mb", 1)
vicious.register(netdownwidget.tb, vicious.widgets.net, " ${enp8s0 down_mb}mb/s", 1)
vicious.register(netupwidget.tb, vicious.widgets.net, "${enp8s0 up_mb}mb/s ", 1)
-- Need a cache since there are 2 of them
vicious.cache(vicious.widgets.net)
vicious.register(clockwidget.tb, vicious.widgets.date, " " .. settings.dateformat, 1)

-- Awesompd
mpd = awesompd:create({
  servers = { { server = "gensokyo", port = 6600 } },
  scrolling = false,
  max_width = 300,
  path_to_icons = awful.util.getdir("config") .. "/awesompd/icons",
  mpd_config = os.getenv("HOME") .. "/.config/mpd/mpd.conf",
  rdecorator = "",
  -- OSD config
  osd = {
    screen = naughty.config.defaults.screen,
    x = -10, -- 10px from right edge
    y = settings.bar_height + 10,
    bar_bg_color = beautiful.bg_focus,
    bar_fg_color = "#987186",
    alt_fg_color = "#9c9898",
  }
})
mpd:register_buttons({
  { "", awesompd.MOUSE_LEFT, mpd:command_playpause() },
  { "", awesompd.MOUSE_SCROLL_UP, mpd:command_volume_up() },
  { "", awesompd.MOUSE_SCROLL_DOWN, mpd:command_volume_down() },
  { "", awesompd.MOUSE_RIGHT, mpd:command_show_menu() }
})

mpdwidget = wibox.container.margin(mpd.widget, 0, 0, -1, 0)


systray = wibox.widget.systray()


awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Tags
  if s.index == 1 then
    awful.tag.add("main", {
      layout                = settings.layouts[1],
      master_fill_policy    = "expand",
      gap_single_client     = true,
      master_width_factor   = .6872,
      screen                = s,
      selected              = true,
    })
    awful.tag.add("dev", {
      layout                = settings.layouts[2],
      master_fill_policy    = "expand",
      gap_single_client     = true,
      master_width_factor   = .6872,
      screen                = s,
    })
    awful.tag.add("media", {
      layout                = settings.layouts[1],
      master_fill_policy    = "expand",
      gap_single_client     = true,
      master_width_factor   = .6872,
      screen                = s,
    })
  else
    awful.tag.add("www", {
      layout                = settings.layouts[2],
      master_fill_policy    = "expand",
      gap_single_client     = true,
      master_width_factor   = .6872,
      screen                = s,
      selected              = true,
    })
    awful.tag.add("doc", {
      layout                = settings.layouts[2],
      master_fill_policy    = "expand",
      gap_single_client     = true,
      master_width_factor   = .6872,
      screen                = s,
    })
  end

  -- Create a promptbox for each screen
  s.promptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.layoutbox = awful.widget.layoutbox(s)
  s.layoutbox:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.layout.inc( 1) end),
  awful.button({ }, 3, function () awful.layout.inc(-1) end),
  awful.button({ }, 4, function () awful.layout.inc( 1) end),
  awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  -- Create a taglist widget
  s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox

  if s.index == 1 then
    s.wibox = awful.wibar(
    {
      position = "top",
      height = settings.bar_height,
      fg = beautiful.fg_normal,
      bg = beautiful.bg_normal,
      screen = s
    })

    -- Add widgets to the wibox
    s.wibox:setup
    {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.taglist,
      s.promptbox,
      s.layoutbox,
    },
    s.tasklist, -- Middle widget
    { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    padding,
    mpdicon,
    mpdwidget,
    separator,
    cpuicon,
    cpuwidget,
    tempicon,
    cputempwidget,
    separator,
    memicon,
    memwidget,
    separator,
    netdownicon,
    netdownwidget,
    netupwidget,
    netupicon,
    separator,
    clockicon,
    clockwidget,
    separator,
    systray},
  }
else
  s.wibox = awful.wibar(
  {
    position = "top",
    height = settings.bar_height,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    screen = s
  })

  -- Add widgets to the wibox
  s.wibox:setup
  {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
    layout = wibox.layout.fixed.horizontal,
    s.taglist,
    s.promptbox,
    s.layoutbox,
  },
  s.tasklist, -- Middle widget
  { -- Right widgets
  layout = wibox.layout.fixed.horizontal,
}
  }
end
end)

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
      awful.client.focus.byidx(1)
      if client.focus then
        client.focus:raise()
      end
    end),
    awful.key({ settings.modkey, "Shift"   }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then
        client.focus:raise()
      end
    end),

    -- Standard program
    awful.key({ settings.modkey,           }, "Return", function () awful.util.spawn(settings.terminal) end),
    awful.key({ settings.modkey, "Control" }, "r", awesome.restart),
    awful.key({ settings.modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ settings.modkey, "Mod1" }, "h",   function() awful.tag.incmwfact(-0.025)             end),
    awful.key({ settings.modkey, "Mod1" }, "j",   function() awful.client.incwfact(0.125)           end),
    awful.key({ settings.modkey, "Mod1" }, "k",   function() awful.client.incwfact(-0.125)            end),
    awful.key({ settings.modkey,		   }, "'",   function() awful.client.setwfact(.682)            end),
    awful.key({ settings.modkey, "Mod1" }, "l",   function() awful.tag.incmwfact(.025)            end),
    awful.key({ settings.modkey, "Shift"   }, "h",   function() awful.client.swap.bydirection("left")  end),
    awful.key({ settings.modkey, "Shift"   }, "k",   function() awful.client.swap.bydirection("down")  end),
    awful.key({ settings.modkey, "Shift"   }, "j",   function() awful.client.swap.bydirection("up")    end),
    awful.key({ settings.modkey, "Shift"   }, "l",	 function() awful.client.swap.bydirection("right") end),

    awful.key({ settings.modkey,           }, "space", function () awful.layout.inc(settings.layouts,  1) end),
    awful.key({ settings.modkey, "Shift"   }, "space", function () awful.layout.inc(settings.layouts, -1) end),

    awful.key({ settings.modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ settings.modkey },            "r",     function () awful.screen.focused().promptbox:run() end)
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
          size_hints_honor = false,
          buttons = clientbuttons,
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap+awful.placement.no_offscreen
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
