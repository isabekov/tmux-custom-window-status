
#!/usr/bin/env bash
set -x

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


main(){
    tmux set-window-option -g "window-status-format" "#[fg=red,bold]#I#[fg=white]:#[default] `\
              `#(${CURRENT_DIR}/get_pane_custom_name.sh `\
              `\"#{pane_pid}\" \"#{pane_current_command}\" \"#{pane_current_path}\" 20 7)"
}

main
