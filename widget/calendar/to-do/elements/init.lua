local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local elements = {}

elements.create = function(title, message)
  local box = {}

  local toDoIcon = wibox.widget {
    image = icons.toDo,
    widget = wibox.widget.imagebox,
  }

  local toDoBg = wibox.widget {
    {
      toDoIcon,
      margins = dpi(5),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = colors.purple,
    widget = wibox.container.background
  }

  local toDoWidget = wibox.widget {
    toDoBg,
    forced_width = 40,
    forced_height = 40,
    widget = clickable_container
  }

  toDoWidget:connect_signal(
    "mouse::enter",
    function()
      toDoBg.bg = colors.pink
      toDoIcon.image = icons.toDoDone
    end
  )

  toDoWidget:connect_signal(
    "mouse::leave",
    function()
      toDoBg.bg = colors.purple
      toDoIcon.image = icons.toDo
    end
  )

  toDoWidget:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          _G.removeToDoElement(box)
        end
      )
    )
  )

  local content = wibox.widget {
    {
      {
        {
          text = title,
          font = 'Inter Bold 10',
          widget = wibox.widget.textbox,
        },
        {
          text = message,
          font = 'Inter 8',
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.vertical,
      },
      margins = dpi(10),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = colors.selection,
    widget = wibox.container.background
  }
  
  box = wibox.widget {
    {
      toDoWidget,
      content,
      layout = wibox.layout.align.horizontal,
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(4))
    end,
    fg = colors.white,
    border_width = dpi(1),
    border_color = colors.background,
    widget = wibox.container.background
  }

  return box
end

return elements