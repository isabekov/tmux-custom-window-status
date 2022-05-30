#!/usr/bin/env bash
# Arg1: #{pane_pid}
# Arg2: #{pane_current_command}
# Arg3: #{pane_current_path}

curps=`ps -f -o cmd --no-headers --ppid $1`
#echo -n $2
if [ -z ${curps} ]; then
  echo -n "$2"
else
  a=${curps%% *}
  b=${curps##* }
  if [ $a = $b ]; then
     echo -n "$a"
  else \
     if [ ${a::3} = 'ssh' ]; then
         echo -n "#[fg=color20,bold]"
     fi
     echo -n "${a##*/} ${b##*/}"
  fi
fi

# Check if command is is "sh", "-sh", "bash", "-bash", "zsh", "-zsh"
if [[ "$2" =~ ^[-]{0,1}(ba|z|)sh ]]; then
  d="${3/\/home\/`whoami`/\~}"
  if [ ${#d} -gt 20 ]; then
      echo -n " ${d::8}...${d: -9}"
  else
      echo -n " ${d}"
      [ "${d}" = "~" ] && echo -n "/"
  fi
fi