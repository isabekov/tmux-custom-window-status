# Checks the process tree checking to see if PID $1 is an ancestor of
# PID $2.  Returns true/false (0/1).
# (Needs error handling to determine if $1 and $2 are provided and both
# are numeric.  Left as an exercise for the reader.)

ps -ea -o pid,ppid |
   awk '{ parent[$1] = $2 }
        END {  if (parent[start] == "")
                   exit 1
               while (lookfor != parent[start] && start != 1)
                   start = parent[start]
               exit start==1 ? 1 : 0
            }' lookfor="$1" start="$2"
