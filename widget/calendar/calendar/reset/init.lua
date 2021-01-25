--DEPENDENCIES
	--whatever is used here idk lol

	local awful = require('awful')
	local wibox = require('wibox')
	local gears = require('gears')
	local clickable_container = require('widget.clickable-container')
	local dpi = require('beautiful').xresources.apply_dpi
	local icons = require('themes.icons')
	local colors = require('themes.dracula.colors')
	local watch = require('awful.widget.watch')
	
	local awful = require('awful')
	local beautiful = require('beautiful')
	local naughty = require('naughty')
	
	local widget_icon = wibox.widget {
		layout = wibox.layout.align.vertical,
		expand = 'none',
		nil,
		{
			id = 'icon',
			image = icons.reset,
			resize = true,
			widget = wibox.widget.imagebox
		},
		nil
	}
	
	local widget = wibox.widget {
		 {
			 {
				 {
					widget_icon,
					layout = wibox.layout.fixed.horizontal,
				},
				margins = dpi(5),
				widget = wibox.container.margin
			},
			widget = clickable_container
		},
		forced_height = dpi(20),
		shape = gears.shape.circle,
		bg = colors.background,
		widget = wibox.container.background
	}
	
	widget:connect_signal(
		"mouse::enter",
		function()
			widget.bg = colors.comment
		end
	)
	
	widget:connect_signal(
		"mouse::leave",
		function()
			widget.bg = colors.background
		end
	)
	
	widget:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					reset_date()
				end
			)
		)
	)
	
	return widget
	