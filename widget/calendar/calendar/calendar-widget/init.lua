local wibox = require('wibox')
local calendar = require('library.wibox.widget.calendar')
local awful = require('awful')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')
local clickable_container = require('widget.clickable-container')

local styles = {}

local cal = wibox.widget {
  date         = os.date('*t'),
  font         = 'Inter 8',
  spacing      = 10,
  week_numbers = false,
  fn_embed = decorate_cell,
  start_sunday = true,
  widget       = calendar.month
}

local function rounded_shape(size)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, size)
  end
end

styles.month   = {
  padding      = 5,
  bg_color     = colors.background,
  border_width = 2,
  shape        = rounded_shape(10),
}

styles.normal = {
  widget   = clickable_container
}

styles.focus   = {
  bg_color = colors.purple,
  fg_color = colors.background,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
  shape    = rounded_shape(5),
  widget   = clickable_container
}

local function update_color()
  if os.date("%Y/%m/%d", os.time(os.date('*t'))) == os.date("%Y/%m/%d", os.time(cal.date)) then
    styles.focus.bg_color = colors.purple
  elseif os.date("%Y/%m/%d", os.time(os.date('*t'))) ~= os.date("%Y/%m/%d", os.time(cal.date)) then
    styles.focus.bg_color = colors.cyan
  end
  cal.date = os.date('*t', os.time(cal.date))
  update_to_do_date_text(os.date("%Y/%m/%d", os.time(cal.date)))
end

local function decorate_cell(widget, flag, date, cell_date)
  local props = styles[flag] or {}

  local ret = wibox.widget {
    {
      {
        widget,
        margins = (props.padding or 2) + (props.border_width or 0),
        widget  = wibox.container.margin
      },
      widget = props.widget or wibox.container.background
    },
    shape              = props.shape,
    fg                 = props.fg_color or colors.foreground,
    bg                 = props.bg_color or 'transparent',
    widget             = wibox.container.background
  }

  ret:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          if (flag == "normal" or flag == "focus") then
            cal:set_date(os.date('*t', os.time(cell_date)))
            update_color()
            updateToDoPanel(cal.date)
          end
        end
      )
    )
  )

  return ret
end

cal.fn_embed = decorate_cell

update_color()

function date_increase()
  cal.date = os.date('*t',os.time(cal.date) + 86400)
  update_color()
  updateToDoPanel(cal.date)
end

function date_decrease()
  cal.date = os.date('*t',os.time(cal.date) - 86400)
  update_color()
  updateToDoPanel(cal.date)
end

function reset_date()
  cal.date = os.date('*t')
  update_color()
  updateToDoPanel(cal.date)
end

function month_increase()
  cal.date = os.date('*t',os.time({year=os.date("%Y", os.time(cal.date)), month=os.date("%m", os.time(cal.date))+1, day=1}))
  update_color()
  updateToDoPanel(cal.date)
end

function month_decrease()
  cal.date = os.date('*t',os.time({year=os.date("%Y", os.time(cal.date)), month=os.date("%m", os.time(cal.date))-1, day=1}))
  update_color()
  updateToDoPanel(cal.date)
end

return cal
