local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local naughty = require('naughty')
local json = require('library.json')

local emptyCenter = require('widget.calendar.to-do.empty')
local width = dpi(400)

local panelLayout = wibox.layout.fixed.vertical()

panelLayout.spacing = dpi(7)
panelLayout.forced_width = width

resetToDoPanelLayout = function()
  panelLayout:reset(panelLayout)
  panelLayout:insert(1, emptyCenter)
end

removeToDoElement = function(box)
  panelLayout:remove_widgets(box)

  if #panelLayout.children == 0 then
    panelLayout:reset(panelLayout)
    panelLayout:insert(1, emptyCenter)
  end
end

local tabSize = function(table) 
  count=0 
  if not pcall(function() for _ in pairs(table) do count = count + 1 end end) then
      return 0
  end
  return count 
end

local box = require("widget.calendar.to-do.elements")

updateToDoPanel = function(date)
  resetToDoPanelLayout()
  awful.spawn.easy_async_with_shell(
    [[cat /home/jeremie1001/.config/awesome/widget/calendar/to-do/to-do-background/todo.json]],
      function(stdout)
        toDoTable = json.parse(stdout)
        
        dateString = "a"..os.date("%Y%m%d", os.time(date))
        
        if tabSize(_G["toDoTable"][dateString]) > 0 then
          panelLayout:reset(panelLayout)
          for i=1, tabSize(_G["toDoTable"][dateString]), 1 do
            panelLayout:insert(1, box.create(_G["toDoTable"][dateString][i].title, _G["toDoTable"][dateString][i].description))
          end
        end
    end
  )
end

return panelLayout