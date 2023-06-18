-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require("deco.wallpaper"),
  taglist   = require("deco.taglist"),
  tasklist  = require("deco.tasklist")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))

  local fancy_taglist = require("deco.fancy_taglist")
    s.mytaglist = fancy_taglist.new({
        screen = s,
        taglist = { buttons = taglist_buttons },
        tasklist = { buttons = tasklist_buttons },
        filter = awful.widget.taglist.filter.all,
    })

  local slidebar = require("deco.slidebar")

    -- Create myslidebar instead of 'mywibox'
    s.myslidebar = slidebar {
    	screen = s,
      bg = "#00000040",
    -- position = "top",
      size = 30,
    -- size_activator = 1
    -- show_delay = 0.25,
    -- hide_delay = 0.5,
    -- easing = 2,
    -- delta = 1,
	}
        
    -- Add widgets to the slidebar
    s.myslidebar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            RC.launcher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            --s.mylayoutbox,
        },
    }
end)
-- }}}
