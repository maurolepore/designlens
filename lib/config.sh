#!/bin/bash

# Configuration management for designlog
# Project-level configuration stored in .designlog.json

# Source colors and logo
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

# Get project config file path
get_config_file() {
  echo ".designlog.json"
}

# Read a config value from project config
read_config() {
  local key="$1"
  local config_file

  config_file=$(get_config_file)

  if [ ! -f "$config_file" ]; then
    return 1  # Config file doesn't exist
  fi

  # Simple JSON extraction (works for simple values)
  grep -o "\"$key\": *[^,}]*" "$config_file" | cut -d':' -f2 | tr -d ' "' || echo "null"
}

# Get config value (returns null if not set)
get_config() {
  local key="$1"
  local value

  value=$(read_config "$key" 2>/dev/null)
  echo "$value"
}

# Write a config value to project config
write_config() {
  local key="$1"
  local value="$2"
  local config_file

  config_file=$(get_config_file)

  if [ ! -f "$config_file" ]; then
    error "$config_file not found. Run 'designlog init' first."
    return 1
  fi

  # Simple JSON update (works for boolean/string values)
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
  local config_file
  config_file=$(get_config_file)

  echo ""
  prompt "To change settings for this project:"
  echo "  designlog config set auto_commit true|false"
  echo ""
  prompt "To view current settings:"
  echo "  designlog config show"
  echo ""
  prompt "To edit directly:"
  echo "  Edit: $config_file"
  echo ""
}

# Command: Show current config
spec_config_show() {
  show_logo

  local config_file

  config_file=$(get_config_file)

  heading "designlog configuration (.designlog.json)"
  echo ""

  if [ -f "$config_file" ]; then
    cat "$config_file"
  else
    info "not configured - run 'designlog init'"
  fi

  echo ""
}

# Command: Set config value
spec_config_set() {
  show_logo

  local key="$1"
  local value="$2"
  local config_file

  config_file=$(get_config_file)

  if [ ! -f "$config_file" ]; then
    error "$config_file not found. Run 'designlog init' first."
    exit 1
  fi

  # Validate boolean values
  if [ "$key" = "auto_commit" ]; then
    if [ "$value" != "true" ] && [ "$value" != "false" ]; then
      error "auto_commit must be true or false"
      exit 1
    fi
  fi

  write_config "$key" "$value"
  success "Updated $config_file"
  echo ""
  info "Current $key: $(get_config "$key")"
}

# Command: Reset config to defaults
spec_config_reset() {
  show_logo

  local config_file

  config_file=$(get_config_file)

  if [ ! -f "$config_file" ]; then
    echo "No project config to reset."
    exit 0
  fi

  echo "Reset $config_file to defaults? (y/n)"
  read -r response

  if [ "$response" = "y" ]; then
    # Remove all custom settings, keep only tool metadata
    sed -i.bak '/auto_commit/d' "$config_file"
    rm -f "$config_file.bak"
    success "Config reset to defaults"
    spec_config_show
  else
    warning "Cancelled."
  fi
}

# Command: Help for config command
spec_config_help() {
  show_logo

  heading "designlog config - Manage project configuration"
  echo ""
  heading "USAGE:"
  echo "  designlog config show                     View current configuration"
  echo "  designlog config set <key> <value>        Set a configuration value"
  echo "  designlog config reset                    Reset config to defaults"
  echo ""
  heading "AVAILABLE SETTINGS:"
  echo "  auto_commit (true|false)                  Auto-commit after tasks complete"
  echo ""
  heading "EXAMPLES:"
  echo "  designlog config show"
  echo "  designlog config set auto_commit true"
  echo "  designlog config set auto_commit false"
  echo ""
  heading "CONFIGURATION FILE:"
  echo "  .designlog.json (project-level config)"
  echo ""
}
