#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pronounce
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author leonid_bobylev79
# @raycast.authorURL https://raycast.com/leonid_bobylev79

source "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
conda activate app
python /Users/leonid/.config/scripts/pronounce.py
