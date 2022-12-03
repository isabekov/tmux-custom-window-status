#!/usr/bin/env bash
# This scripts produces (prints) a custom name for a pane in a tmux session.
#
# Features:
# - instead of the short #{pane_current_command} with no arguments, full name
#   of the executed command (with arguments) of the current process is abbreviated
# - directory names are printed only for "sh", "zsh" and "bash" shells
# - abbreviation of directory name from the beginning and the end of its name
# - "/home/`whoami`"" is replaced with "~/" in directory name
# - SSH session names (as invoked) are highlighted with a different color,
#   no directory name is displayed

# arg1: #{pane_pid}
# arg2: #{pane_current_command}
# arg3: #{pane_current_path}
# arg4: number of characters used for abbreviation of directory names
# arg5: number of characters to abbreviate from the beginning of directory name (condition: arg5 < arg4)

if [ $# -eq 4 ]; then
   # Length of the abbreviated directory name
   na=${4}
   # Subtract length of placeholder for "..." from the final length,
   # and try to assign equal lengths for abbreviation from front ("nf") and back ("nb")
   nf=$(( (${na} - 3) /2 ))
   nb=$(( ${nf} + $(( (${na} - 3)%2)) ))
fi

if [ $# -eq 5 ]; then
  na=${4}
  if [ ${5} -le $(( ${na}-3 )) ]; then
     # Directory name should be abbreviated to "nf" characters from the beginning
     nf=${5}
     nb=$(( ${na} - 3 - ${nf} ))
  else
     nf=$(( ${na} - 3 ))
     nb=0
  fi
fi

# Retrieve full executed command name (with arguments) of the current process in the pane
curps=`ps -f -o comm --no-headers --ppid $1`

if [ -z ${curps} ]; then
  echo -n "$2"
else
  # Delete all characters till the last occurence (counted from back)
  # of a whitespace inclusively from back of string "$a"
  a=${curps%% *}

  # Delete all characters till the last occurence (counted from front)
  # of a whitespace inclusively from front of string "$a"
  b=${curps##* }

  if [ $a = $b ]; then
     # There are no arguments to the command "$a"
     echo -n "$a"
  else
     if [ ${a::3} = 'ssh' ]; then
         # Highlight SSH sessions with a special color
         echo -n "#[fg=red,bold]"
     fi
     echo -n "${a##*/} ${b##*/}"
  fi
fi

echo -n "#[fg=color90]"
# Check if executed command is is "sh", "-sh", "bash", "-bash", "zsh", "-zsh"
# Dash ("-") in front of a shell name means it is a login shell
if [[ "$2" =~ ^[-]{0,1}(ba|z|)sh ]]; then

  # If it is user's home directory, replace it with "~"
  d="${3/\/home\/`whoami`/\~}"

  if [ ${#d} -gt ${na} ]; then
      if [ ${nb} -ne 0 ]; then
          # Abbreviate directory name from the beginning and the end
          echo -n " ${d::${nf}}...${d: -${nb}}"
      else
          # Abbreviate directory name only from the beginning of the name
          echo -n " ${d::${nf}}..."
      fi
  else
      # Directory name is shorter than allowed length, display it fully
      echo -n " ${d}"
      # If it is user's home directory "~", append "/" at the end
      [ "${d}" = "~" ] && echo -n "/"
  fi
fi