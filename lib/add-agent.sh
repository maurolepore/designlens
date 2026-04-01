#!/bin/bash

# Agent scaffolding library
# Provides reusable functions for installing agent-specific files

get_lib_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

get_commands_dir() {
  local lib_dir
  lib_dir=$(get_lib_dir)
  echo "$lib_dir/../commands"
}

add_agent_claude() {
  local lib_dir
  lib_dir=$(get_lib_dir)
  local commands_dir
  commands_dir=$(get_commands_dir)

  mkdir -p .claude/commands
  cp "$commands_dir"/*.md .claude/commands/
  success "Installed command files to .claude/commands/"
  echo ".claude/commands"

  local hooks_dir="$lib_dir/hooks"
  if [ -d "$hooks_dir" ]; then
    local session_start_hook_path="$lib_dir/hooks/session_start.sh"
    local post_hook_path="$lib_dir/hooks/post_tool_use.sh"
    local stop_hook_path="$lib_dir/hooks/stop.sh"
    local settings_file=".claude/settings.json"
    local hook_config
    hook_config=$(jq -n \
      --arg start "$session_start_hook_path" \
      --arg post "$post_hook_path" \
      --arg stop "$stop_hook_path" \
      '{hooks: {SessionStart: [{hooks: [{type: "command", command: $start}]}], PostToolUse: [{matcher: "Write|Edit", hooks: [{type: "command", command: $post}]}], Stop: [{hooks: [{type: "command", command: $stop}]}]}}')
    if [ -f "$settings_file" ]; then
      local merged
      merged=$(jq -s '.[0] * .[1]' "$settings_file" <(echo "$hook_config") 2>/dev/null) || merged=""
      if [ -n "$merged" ]; then
        echo "$merged" > "$settings_file"
        success "Merged designlens hooks into .claude/settings.json"
      else
        warning "Could not merge hooks into existing .claude/settings.json — add hooks manually."
        info "  PostToolUse: $post_hook_path"
        info "  Stop: $stop_hook_path"
      fi
    else
      echo "$hook_config" > "$settings_file"
      success "Created .claude/settings.json with designlens hooks"
    fi
  fi

  echo "claude"
}

add_agent_opencode() {
  local lib_dir
  lib_dir=$(get_lib_dir)
  local commands_dir
  commands_dir=$(get_commands_dir)

  mkdir -p .opencode/command
  cp "$commands_dir"/*.md .opencode/command/
  success "Installed command files to .opencode/command/"
  echo ".opencode/command"

  mkdir -p .opencode/tools
  local tools_dir="$lib_dir/tools"
  if [ -d "$tools_dir" ]; then
    cp "$tools_dir"/get_session_stats.* .opencode/tools/ 2>/dev/null || true
    success "Installed session stats tools to .opencode/tools/"
  fi

  echo "opencode"
}

add_agent() {
  local agent="$1"
  local installed_agents=()
  local installed_paths=()

  case "$agent" in
    claude)
      local path
      local name
      path=$(add_agent_claude)
      name="claude"
      installed_paths+=("$path")
      installed_agents+=("$name")
      ;;
    opencode)
      local path
      local name
      path=$(add_agent_opencode)
      name="opencode"
      installed_paths+=("$path")
      installed_agents+=("$name")
      ;;
    *)
      echo "Unknown agent: $agent" >&2
      return 1
      ;;
  esac

  local agents_json commands_json tmp_cfg
  agents_json=$(printf '%s\n' "${installed_agents[@]}" | jq -R . | jq -s .)
  commands_json=$(printf '%s\n' "${installed_paths[@]}" | jq -R . | jq -s .)
  tmp_cfg=$(jq --argjson a "$agents_json" --argjson c "$commands_json" \
    '.agent = $a | .commands_path = $c' .designlens.json 2>/dev/null) || tmp_cfg=""
  [ -n "$tmp_cfg" ] && echo "$tmp_cfg" > .designlens.json
  success "Updated .designlens.json"

  git add .designlens.json
  for p in "${installed_paths[@]}"; do
    git add "$p/" 2>/dev/null || true
  done
  [ -d ".claude/settings.json" ] || [ -f ".claude/settings.json" ] && git add .claude/settings.json 2>/dev/null || true
  [ -d ".opencode/tools" ] && git add .opencode/tools/ 2>/dev/null || true
  success "Staged new files"

  local auto_commit
  auto_commit=$(get_config "auto_commit")
  if [ "$auto_commit" = "true" ]; then
    git commit -m "Add agent scaffolding" > /dev/null 2>&1
    success "Changes committed"
  fi
}

spec_add_agent() {
  local lib_dir
  lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source "$lib_dir/colors.sh"
  source "$lib_dir/config.sh"

  show_logo

  if ! command -v jq &>/dev/null; then
    error "jq is required but not installed. See https://jqlang.org/download/"
    exit 1
  fi

  if [ ! -f .designlens.json ]; then
    error "Project is not initialized (.designlens.json not found). Run 'designlens init' first."
    exit 1
  fi

  local has_claude=false
  local has_opencode=false
  [ -d ".claude" ] && has_claude=true
  [ -d ".opencode" ] && has_opencode=true

  if [ "$has_claude" = true ] && [ "$has_opencode" = true ]; then
    error "Both .claude/ and .opencode/ are already installed. No additional agents to add."
    exit 1
  elif [ "$has_claude" = true ]; then
    prompt "Only Claude Code is installed. Add OpenCode? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
      add_agent opencode
    else
      info "Cancelled."
      exit 0
    fi
  elif [ "$has_opencode" = true ]; then
    prompt "Only OpenCode is installed. Add Claude Code? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
      add_agent claude
    else
      info "Cancelled."
      exit 0
    fi
  else
    error "No agent directories detected. Run 'designlens init' first."
    exit 1
  fi

  echo ""
  success "Agent added successfully!"

  echo ""
  rule
  echo ""

  heading "━ Next steps ━"
  local step=1
  local auto_commit
  auto_commit=$(get_config "auto_commit")
  if [ "$auto_commit" != "true" ]; then
    echo "  $step. Commit the changes: git commit -m 'Add agent scaffolding'"
    step=$((step + 1))
  fi
  echo "  $step. You can now use both agents with designlens"
}
