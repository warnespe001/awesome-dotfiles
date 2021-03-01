#!/bin/bash

# Intended to be called from ~/.xbindkeysrc when VOL_+ or VOL_- is pressed, with --inc/--dec in $1, and an amount in $2.
# Presently, this doesn't do a whole lot of error checking.

# TODO: Find a way to show this in a pretty way, like some sort of non-interactive widget that appears for X seconds

touch /tmp/awesome_volume_notif.id

function notify() {
    # Args:
    #   title
    #   text

    awesome-client " 
        file_read = io.open('/tmp/awesome_volume_notif.id', 'r')
        io.input(file_read)
        last_notif_id = io.read()
        io.close(file_read)

        naughty = require('naughty')
        colors = require('themes.dracula.colors')

        if last_notif_id == nil or naughty.getById(tonumber(last_notif_id)) == nil then
            notif = naughty.notify({title='$1', text='$2', fg=colors.yellow})
            notif_id = notif['id']

            file_write = io.open('/tmp/awesome_volume_notif.id', 'w')
            io.output(file_write)
            io.write(tostring(notif_id))
            io.close(file_write)
        else
            naughty.notify({title='$1', text='$2', fg=colors.yellow, replaces_id=tonumber(last_notif_id)})
        end
    "
}

if [[ "$1" == "--inc" ]]; then
    pamixer --sink 1 --increase $2 
elif [[ "$1" == "--dec" ]]; then
    pamixer --sink 1 --decrease $2
else
    notify "Error" "Invalid args to $0"
    exit 1
fi

vol=`pamixer --sink 1 --get-volume`

notify "Volume Changed" "$vol%"
