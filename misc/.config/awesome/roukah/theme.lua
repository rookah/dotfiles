local awful = require("awful")

theme   = { }
confdir = awful.util.getdir("config") .. "/roukah"

theme.wallpaper = "~/Pictures/Wallpapers/Current/maki.png"
theme.void_wallpaper = "~/Pictures/Wallpapers/Current/pink.png"

theme.font		= "artwiz cure 8"

theme.fg_normal = "#eeeed5"
theme.fg_focus  = "#dddada"
theme.fg_urgent = "#e0dddd"
theme.bg_normal = "#573355"
theme.bg_focus  = "#40263f"
theme.bg_urgent = "#282828"

theme.border_width  = 2
theme.border_normal = "#2a2a2a"
theme.border_focus  = "#c97aa4"
theme.border_marked = "#6f3332"

theme.menu_height = 16
theme.menu_border_width = 1
theme.menu_border_color = "#282828"

theme.useless_gap = 8
theme.tasklist_disable_icon = true
theme.tasklist_align = "center"
theme.tasklist_sticky = ""
theme.tasklist_ontop = ""
theme.tasklist_above = ""
theme.tasklist_below = ""
theme.tasklist_floating = ""
theme.tasklist_maximized = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical = ""

theme.systray_icon_spacing = 0

theme.taglist_squares_sel   = confdir .. "/icons/taglist/squarefza.png"
theme.taglist_squares_unsel = confdir .. "/icons/taglist/squareza.png"

theme.widget_net        = confdir .. "/icons/vicious/net_down_03.png"
theme.widget_netup      = confdir .. "/icons/vicious/net_up_03.png"
theme.widget_clock      = confdir .. "/icons/vicious/clock.png"
theme.widget_mem        = confdir .. "/icons/vicious/mem.png"
theme.widget_cputemp    = confdir .. "/icons/vicious/temp.png"
theme.widget_cpu        = confdir .. "/icons/vicious/cpu.png"
theme.widget_mpd        = confdir .. "/icons/vicious/note.png"

theme.layout_floating   = confdir .. "/icons/layouts/floating.png"
theme.layout_tile     = confdir .. "/icons/layouts/tile.png"
theme.layout_tileleft = confdir .. "/icons/layouts/tileleft.png"

theme.menu_submenu_icon = confdir .. "/icons/menu/sub_menu.png"
theme.menu_terminal     = confdir .. "/icons/menu/terminal.png"
theme.menu_wbrowser     = confdir .. "/icons/menu/wbrowser.png"
theme.menu_fbrowser     = confdir .. "/icons/menu/fbrowser.png"
theme.menu_rwall        = confdir .. "/icons/menu/rwall.png"
theme.menu_suspend      = confdir .. "/icons/menu/suspend.png"
theme.menu_reboot       = confdir .. "/icons/menu/reboot.png"
theme.menu_shutdown     = confdir .. "/icons/menu/shutdown.png"

return theme
