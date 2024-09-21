#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ssh Build Sever
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author leonid_bobylev79
# @raycast.authorURL https://raycast.com/leonid_bobylev79

osascript -e 'tell application "iTerm2"
    create window with default profile
    tell current session of current window
        write text "ssh -t leo@build.cp-bc.com \"cd src/random-scripts && tmux\""
    end tell
end tell'


