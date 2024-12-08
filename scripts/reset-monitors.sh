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

id1="8D180489-3FED-41EC-B288-7D3DADB00632"
id2="85177CDE-8910-4D52-A4E4-CE9F8DC53B4F"

function reset() {
    local id=$1
    local resolution=$2
    displayplacer "id:$id res:$resolution hz:75 color_depth:8"
    displayplacer "id:$id res:$resolution hz:100 color_depth:8"
}

reset "$id1" "1080x1920"
reset "$id2" "1920x1080"
