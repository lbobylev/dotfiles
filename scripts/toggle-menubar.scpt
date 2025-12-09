#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Menubar
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

tell application "System Events"
    tell dock preferences
        set autohide menu bar to not autohide menu bar
    end tell
end tell
