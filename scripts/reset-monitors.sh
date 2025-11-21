#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reset Monitors
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author leonid_bobylev79
# @raycast.authorURL https://raycast.com/leonid_bobylev79

id1="1109DB90-0CF3-4945-94AD-B0D9F1EE2622"
id2="8BCE58AD-AEBE-42DF-AB9A-09A339E7D1D4"

pmset sleepnow
sleep 1  # Wait for 1 second
caffeinate -u -t 1  # Prevent sleep and simulate user activity for 1 second

# function reset() {
#     local id=$1
#     local resolution=$2
#     /opt/homebrew/bin/displayplacer "id:$id res:$resolution hz:75 color_depth:8"
#     /opt/homebrew/bin/displayplacer "id:$id res:$resolution hz:100 color_depth:8"
# }
#
# reset "$id1" "1080x1920"
# reset "$id2" "1920x1080"
