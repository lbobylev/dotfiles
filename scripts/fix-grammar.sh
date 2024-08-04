#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Fix Grammar
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author leonid_bobylev79
# @raycast.authorURL https://raycast.com/leonid_bobylev79

export OPENAI_API_KEY=`cat /Users/leonid/.openai`

source "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
conda activate scripts
python /Users/leonid/.config/scripts/fix-grammar.py
/opt/homebrew/Cellar/terminal-notifier/2.0.0/bin/terminal-notifier -title "Grammar Fix" -message "Grammar fixed"
