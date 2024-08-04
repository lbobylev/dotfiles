#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title My Agent
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author leonid_bobylev79
# @raycast.authorURL https://raycast.com/leonid_bobylev79
# raycast.argument1 { "type": "text", "placeholder": "repo" }
# @raycast.argument1 { "type": "text", "placeholder": "prompt" }

export OPENAI_API_KEY=`cat /Users/leonid/.openai`
export GITHUB_APP_ID=1123284
export GITHUB_APP_PRIVATE_KEY=/Users/leonid/Downloads/leo-agent.2025-01-25.private-key.pem
#export GITHUB_REPOSITORY="${1// /%20}"

source "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
conda activate base
python /Users/leonid/.config/scripts/my-agent.py "${1// /%20}"
