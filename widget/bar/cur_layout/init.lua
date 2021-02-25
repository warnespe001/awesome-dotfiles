local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')

local return_button = function(color, space)
	local widget_content = wibox.widget {
		text = awful.layout.getname(awful.layout.get(awful.screen.focused())),
		widget = wibox.widget.textbox
	}

	local lenMax = 42

	local widget_button = wibox.widget {
	     {
	       {
	         {
						 {
		          widget_content,
							layout = wibox.layout.fixed.horizontal,
		        },
						top = dpi(4),
						bottom = dpi(4),
						left = dpi(12),
						right = dpi(12),
		        widget = wibox.container.margin
					},
					shape = gears.shape.rounded_bar,
					bg = color,
					fg = 'white',
					widget = wibox.container.background
	      },
	      widget = clickable_container
	    },
			top = dpi(5),
	    left = dpi(space),
	    widget = wibox.container.margin
  	}

		widget_button:connect_signal(
			"mouse::enter",
			function()
				lenMax = 300
			end
		)

		widget_button:connect_signal(
			"mouse::leave",
			function()
				lenMax = 42
			end
		)

        tag.connect_signal(
            "property::layout",
            function(t)
                if t.screen.index == awful.screen.focused().index then
		            widget_content.text = awful.layout.getname(awful.layout.get(t.screen))
                end
            end
        )

        tag.connect_signal(
            "property::selected",
            function(s)
                if s then
		            widget_content.text = awful.layout.getname(awful.layout.get(tag.screen))
                end
            end
        )

        -- TODO: Find a way to make each screen display their own layout; currently, this widget is "linked" across screens

	return widget_button
end

return return_button
