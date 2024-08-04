#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title screenshot
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Take screenshot
# @raycast.author leonid_bobylev79
# @raycast.authorURL https://raycast.com/leonid_bobylev79

#!/bin/bash

# Define the output directory and filename
OUTPUT_DIR="$HOME/Downloads"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="screenshot_$TIMESTAMP.png"
FILEPATH="$OUTPUT_DIR/$FILENAME"

# Take a screenshot of a selected area using selection mode
# -s: Force selection mode (draw a rectangle)
# -x: Do not play sounds (optional)
screencapture -i "$FILEPATH"

# Check if the screenshot was taken successfully
# We check if the command succeeded ($? -eq 0) and if the file exists
if [ $? -eq 0 ] && [ -f "$FILEPATH" ]; then
   # Copy the full path to the clipboard
   echo ".file $FILEPATH" | pbcopy
   echo "Screenshot saved to $FILEPATH"
   echo "Path copied to clipboard."
else
   echo "Screenshot failed or was cancelled."
   # Optionally remove the empty file if screencapture creates one on failure/cancel
   # rm -f "$FILEPATH"
fi
