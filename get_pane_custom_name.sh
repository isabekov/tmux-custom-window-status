#!/usr/bin/env bash
# arg1: #{pane_pid}
# arg2: #{pane_current_command}
# arg3: #{pane_current_path}
# arg4: number of characters after which directory name shortening will be applied
# arg5: number of characters to show from the beginning ("front") of the directory name (condition: arg5 < arg4)

if [ $# -eq 4 ]; then
   na=${4}
   nf=$(( (${na} - 3) /2 ))
   nb=$(( ${nf} + $(( (${na} - 3)%2)) ))
fi

if [ $# -eq 5 ]; then
  na=${4}
  if [ ${5} -le $(( ${na}-3 )) ]; then
     nf=${5}
     nb=$(( ${na} - 3 - ${nf} ))
  else
     nf=$(( ${na} - 3 ))
     nb=0
  fi
fi


curps=`ps -f -o cmd --no-headers --ppid $1`

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

echo -n "#[fg=color21]"
# Check if command is is "sh", "-sh", "bash", "-bash", "zsh", "-zsh"
if [[ "$2" =~ ^[-]{0,1}(ba|z|)sh ]]; then
  d="${3/\/home\/`whoami`/\~}"
  if [ ${#d} -gt ${na} ]; then
      if [ ${nb} -ne 0 ]; then
          echo -n " ${d::${nf}}...${d: -${nb}}"
      else
          echo -n " ${d::${nf}}..."
      fi
  else
      echo -n " ${d}"
      [ "${d}" = "~" ] && echo -n "/"
  fi
fi