#!/bin/bash

# Configuration management for designlog
# Handles global user config and local project overrides

# Get global config directory
get_config_dir() {
  echo "${HOME}/.designlog"
}

# Get global config file path
get_global_config() {
  echo "$(get_config_dir)/config.json"
}

# Get local project config file path
get_local_config() {
  echo ".designlog.json"
}

# Initialize global config with defaults
init_global_config() {
  local config_dir
  local config_file

  config_dir=$(get_config_dir)
  config_file="$config_dir/config.json"

  mkdir -p "$config_dir" 2>/dev/null

  if [ ! -f "$config_file" ]; then
    cat > "$config_file" << 'EOF'
{
  "auto_commit": false,
  "version": "1"
}
EOF
    return 1  # Config was newly created
  fi
  return 0  # Config already existed
}

# Read a config value from global config
read_global_config() {
  local key="$1"
  local config_file

  config_file=$(get_global_config)

  if [ ! -f "$config_file" ]; then
    return 1  # Config doesn't exist
  fi

  # Simple JSON extraction (works for simple values)
  grep -o "\"$key\": *[^,}]*" "$config_file" | cut -d':' -f2 | tr -d ' "' || echo "null"
}

# Read a config value from local config (if it exists)
read_local_config() {
  local key="$1"
  local config_file

  config_file=$(get_local_config)

  if [ ! -f "$config_file" ]; then
    return 1  # Local config doesn't exist
  fi

  # Simple JSON extraction
  grep -o "\"$key\": *[^,}]*" "$config_file" | cut -d':' -f2 | tr -d ' "' || echo "null"
}

# Get effective config value (local overrides global)
get_config() {
  local key="$1"
  local local_value
  local global_value

  # Try local config first
  local_value=$(read_local_config "$key" 2>/dev/null)
  if [ "$local_value" != "null" ] && [ -n "$local_value" ]; then
    echo "$local_value"
    return 0
  fi

  # Fall back to global config
  global_value=$(read_global_config "$key" 2>/dev/null)
  if [ "$global_value" != "null" ] && [ -n "$global_value" ]; then
    echo "$global_value"
    return 0
  fi

  echo "null"
  return 1
}

# Write a config value to global config
write_global_config() {
  local key="$1"
  local value="$2"
  local config_file

  config_file=$(get_global_config)

  if [ ! -f "$config_file" ]; then
    init_global_config
  fi

  # Simple JSON update (works for boolean/string values)
  # This is a bit hacky but avoids dependency on jq
  local temp_file
  temp_file=$(mktemp)

  if grep -q "\"$key\":" "$config_file"; then
    # Key exists, replace it
    sed "s/\"$key\": *[^,}]*/\"$key\": $value/" "$config_file" > "$temp_file"
  else
    # Key doesn't exist, add it before the closing brace
    sed "s/}/,\n  \"$key\": $value\n}/" "$config_file" > "$temp_file"
  fi

  mv "$temp_file" "$config_file"
}

# Show how to change config
show_config_help() {
  local config_dir
  config_dir=$(get_config_dir)

  echo ""
  echo "To change your global setting (applies to all projects):"
  echo "  designlog config set auto_commit true|false"
  echo ""
  echo "To override for just this project:"
  echo "  Edit: .designlog.json"
  echo "  Add to it:"
  echo "    \"auto_commit\": false"
  echo "  (project settings override your global preference)"
  echo ""
  echo "To view all settings:"
  echo "  designlog config show"
  echo ""
}

# Command: Show current config
spec_config_show() {
  local config_dir
  local config_file
  local global_value
  local local_value

  config_dir=$(get_config_dir)
  config_file="$config_dir/config.json"

  echo "designlog configuration"
  echo ""
  echo "Global config: $config_file"

  if [ -f "$config_file" ]; then
    cat "$config_file"
  else
    echo "(not yet configured)"
  fi

  echo ""
  echo "Project metadata and local config: .designlog.json"

  if [ -f ".designlog.json" ]; then
    cat ".designlog.json"
  else
    echo "(not configured for this project)"
  fi

  echo ""
  echo "Effective settings:"
  echo "  auto_commit: $(get_config "auto_commit")"
}

# Command: Set config value
spec_config_set() {
  local key="$1"
  local value="$2"
  local config_dir

  config_dir=$(get_config_dir)

  # Validate boolean values
  if [ "$key" = "auto_commit" ]; then
    if [ "$value" != "true" ] && [ "$value" != "false" ]; then
      echo "Error: auto_commit must be true or false"
      exit 1
    fi
  fi

  write_global_config "$key" "$value"
  echo "✓ Updated $config_dir/config.json"
  echo ""
  echo "Effective $key: $(get_config "$key")"
}

# Command: Reset config to defaults
spec_config_reset() {
  local config_dir
  local config_file

  config_dir=$(get_config_dir)
  config_file="$config_dir/config.json"

  if [ ! -f "$config_file" ]; then
    echo "No global config to reset."
    exit 0
  fi

  echo "Reset global config to defaults? (y/n)"
  read -r response

  if [ "$response" = "y" ]; then
    rm "$config_file"
    init_global_config
    echo "✓ Config reset to defaults"
    spec_config_show
  else
    echo "Cancelled."
  fi
}

# Command: Help for config command
spec_config_help() {
  echo "designlog config - Manage global and project-specific settings"
  echo ""
  echo "USAGE:"
  echo "  designlog config show                     View current configuration"
  echo "  designlog config set <key> <value>        Set a configuration value"
  echo "  designlog config reset                    Reset global config to defaults"
  echo ""
  echo "AVAILABLE SETTINGS:"
  echo "  auto_commit (true|false)                  Auto-commit after tasks complete"
  echo ""
  echo "EXAMPLES:"
  echo "  designlog config show"
  echo "  designlog config set auto_commit true"
  echo "  designlog config set auto_commit false"
  echo ""
  echo "CONFIGURATION FILES:"
  echo "  Global user default: ~/.designlog/config.json"
  echo "  Project-specific: .designlog.json (contains metadata + config)"
  echo ""
}
