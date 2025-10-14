#!/bin/bash
 
# Function to display the progress bar
progress_bar() {
  local duration=${1}
    
  already_done() { for ((done=0; done<$1; done++)); do printf "#"; done }
  remaining() { for ((remain=$1; remain<$duration; remain++)); do printf " "; done }
  percentage() { printf "| %s%%" $(( (($1)*100)/($duration)*100/100 )); }
  clean_line() { printf "\r"; }
 
  for (( current_duration=1; current_duration<=$duration; current_duration++ )); do
    already_done $current_duration
    remaining $current_duration
    percentage $current_duration
    clean_line
    sleep 1
  done
 
  clean_line
}
 
# Call the function with the specific duration
progress_bar 40
