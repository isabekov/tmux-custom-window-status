
#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


custom_pane_name="#(${CURRENT_DIR}/get_pane_custom_name.sh `\
                  `\"#{pane_pid}\" \"#{pane_current_command}\" \"#{pane_current_path}\" 20 7)"

placeholder="\#{custom_pane_name}"

get_tmux_window_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqvw "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_window_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gqw "$option" "$value"
}

do_interpolation() {
	local string="$1"
	local interpolated="${string/${placeholder}/${custom_pane_name}}"
	echo "$interpolated"
}

update_tmux_window_option() {
	local option="$1"
	local option_value="$(get_tmux_window_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_window_option "$option" "$new_option_value"
}

main() {
  update_tmux_window_option "window-status-format"
  update_tmux_window_option "window-status-current-format"
}

main