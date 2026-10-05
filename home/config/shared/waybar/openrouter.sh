#!/usr/bin/env bash

KEY_FILE="/run/secrets/openrouter/key"

[ -r "$KEY_FILE" ] || {
  echo '{"text": "󰚩", "class": "disconnected", "tooltip": "No OpenRouter secret at /run/secrets/openrouter/key"}'
  exit 0
}

KEY=$(cat "$KEY_FILE")

JSON_CREDITS=$(curl -sf --max-time 10 https://openrouter.ai/api/v1/credits \
  -H "Authorization: Bearer $KEY") || {
  echo '{"text": "󰚩", "class": "disconnected", "tooltip": "OpenRouter API unreachable"}'
  exit 0
}

JSON_KEY=$(curl -sf --max-time 10 https://openrouter.ai/api/v1/key \
  -H "Authorization: Bearer $KEY") || {
  echo '{"text": "󰚩", "class": "disconnected", "tooltip": "OpenRouter API unreachable"}'
  exit 0
}

TOTAL=$(jq -r '.data.total_credits // .total_credits // empty' <<<"$JSON_CREDITS")
USED=$(jq -r '.data.total_usage // .total_usage // empty' <<<"$JSON_CREDITS")
MONTHLY=$(jq -r '.data.usage_monthly // .usage_monthly // empty' <<<"$JSON_KEY")

[ -n "$TOTAL" ] && [ -n "$USED" ] && [ -n "$MONTHLY" ] || {
  echo '{"text": "󰚩", "class": "disconnected", "tooltip": "Unexpected OpenRouter API response"}'
  exit 0
}

awk -v total="$TOTAL" -v used="$USED" -v monthly="$MONTHLY" '
BEGIN {
  remain = total - used
  text = sprintf("$%.2f / $%.2f", monthly, remain)
  tooltip = sprintf("OpenRouter (this month)\nSpent: $%.2f\nRemaining credits: $%.2f\nTotal spent (all time): $%.2f", monthly, remain, used)
  if (remain < 5) class = "critical"
  else if (remain < 10) class = "warning"
  else class = "ok"
  gsub(/\\/, "\\\\\\\\", tooltip)
  gsub(/"/, "\\\\\"", tooltip)
  gsub(/\n/, "\\\\n", tooltip)
  gsub(/\t/, "\\\\t", tooltip)
  printf "{\"text\": \"%s\", \"class\": \"%s\", \"tooltip\": \"%s\"}\n", text, class, tooltip
}'
