#!/bin/bash

# Read all input (multi-line JSON)
input=$(cat)

# Parse JSON using jq
agent_name=$(echo "$input" | jq -r '.agent_name')
safe_name=$(echo "$input" | jq -r '.safe_name')
agent_data=$(echo "$input" | jq -r '.agent_data')
commit_message=$(echo "$input" | jq -r '.commit_message')
description=$(echo "$input" | jq -r '.description')
timestamp=$(echo "$input" | jq -r '.timestamp')

# Create directory
mkdir -p "/opt/glumpe-ai-agents/agents/$safe_name"

# Write workflow file
echo "$agent_data" > "/opt/glumpe-ai-agents/agents/$safe_name/workflow.json"

# Write README
cat > "/opt/glumpe-ai-agents/agents/$safe_name/README.md" << READMEEOF
# $agent_name

$description

## Type
workflow

## Created
$timestamp

## Files
- \`workflow.json\` - N8N workflow definition

## Usage
This agent is managed by the Meta-Agent system.
READMEEOF

# Git operations
cd /opt/glumpe-ai-agents
git add .
git commit -m "$commit_message" || true
git push origin main

echo '{"success": true, "message": "Agent synced to GitHub", "agent_name": "'"$agent_name"'", "safe_name": "'"$safe_name"'", "github_url": "https://github.com/glumpe/glumpe-ai-agents/tree/main/agents/'"$safe_name"'"}'
