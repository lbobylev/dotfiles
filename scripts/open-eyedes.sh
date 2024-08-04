#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Eyedes
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author leonid_bobylev79
# @raycast.authorURL https://raycast.com/leonid_bobylev79

osascript -e 'tell application "iTerm" to create window with default profile' \
-e 'tell application "iTerm" to tell current session of current window to write text "cd ~/src/ewc-app-eyedes && vim -c \"e src/main/java/eu/surgetech/ewc/eyedes/Application.java\" "'

