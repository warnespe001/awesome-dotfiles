local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

--- Construction of To do portion of right side calendar panel 


-- Added module for converting between lua tables and json files
  -- json file widget/calendar/to-do/to-do-background/todo.json used for storing to do events through restarts
  -- json.stringify : lua table -> json object as a string
  -- json.parse: json object as a string -> lua table
local json = require('library.json')

-- Import element to be used when to do list is empty
local emptyCenter = require('widget.calendar.to-do.empty')

-- Define wid of panel
local width = dpi(400)

-- Define base panelLayout properties
local panelLayout = wibox.layout.fixed.vertical()
panelLayout.spacing = dpi(7)
panelLayout.forced_width = width

-- Function that resets entire panel to empty
resetToDoPanelLayout = function()
  panelLayout:reset(panelLayout)
  panelLayout:insert(1, emptyCenter)
end

-- Function that removes specific elements from panel
  -- If element is removed and the panel becomes empty, add empty element
removeToDoElement = function(box)
  panelLayout:remove_widgets(box)

  if #panelLayout.children == 0 then
    panelLayout:reset(panelLayout)
    panelLayout:insert(1, emptyCenter)
  end
end

-- Get size of lua table, return 0 if it does not exist
local tabSize = function(table) 
  count=0 
  if not pcall(function() for _ in pairs(table) do count = count + 1 end end) then
      return 0
  end
  return count 
end

-- Import file function which creates elements given specififed title and message strings 
local box = require("widget.calendar.to-do.elements")

-- Function that updates to do panel with elements drawn from json file
updateToDoPanel = function(date)

  -- Reset panel to empty
  resetToDoPanelLayout()

  awful.spawn.easy_async_with_shell(

    -- Read json file in as string called stdout
    [[cat /home/jeremie1001/.config/awesome/widget/calendar/to-do/to-do-background/todo.json]],
    function(stdout)

      -- Convert json table string to lua table
      toDoTable = json.parse(stdout)
      
      -- Create key for date being updated to
        -- The keys follow a 'aYYYYMMDD' format
        -- The starting 'a' is added since json key must be a string
      dateString = "a"..os.date("%Y%m%d", os.time(date))
      
      -- If there are entries for the date remove empty element, and insert an element for each entry
        -- _G[string] allows the use of a string as a variable name
          -- Used for lua table referencing
        -- If status variable is  = 1, it means the task is done and do not insert it (not done this feature yet)
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