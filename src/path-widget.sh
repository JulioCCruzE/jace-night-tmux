#!/usr/bin/env bash

# Imports
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
. "${ROOT_DIR}/lib/coreutils-compat.sh"

# get value from tmux config
SHOW_PATH=$(tmux show-option -gv @tokyo-night-tmux_show_path 2>/dev/null)
PATH_FORMAT=$(tmux show-option -gv @tokyo-night-tmux_path_format 2>/dev/null) # full | relative
RESET="#[fg=brightwhite,bg=#15161e,nobold,noitalics,nounderscore,nodim]"

# check if not enabled
if [ "${SHOW_PATH}" != "1" ]; then
  exit 0
fi

current_path="${1}"
default_path_format="relative"
PATH_FORMAT="${PATH_FORMAT:-$default_path_format}"

# check user requested format
if [[ ${PATH_FORMAT} == "relative" ]]; then
  current_path="$(echo ${current_path} | sed 's#'"$HOME"'#~#g')"
fi

# MAX_TITLE_WIDTH=5
# if [ "${current_path}" -ge $MAX_TITLE_WIDTH ]; then
#   current_path="${current_path:0:$MAX_TITLE_WIDTH-1}"
#   # Remove trailing spaces
#   current_path="${current_path%"${current_path##*[![:space:]]}"}…"
# fi

OUTPUT=${current_path}
TITLE=${current_path}
MAX_TITLE_WIDTH=25
if [ "${#OUTPUT}" -ge $MAX_TITLE_WIDTH ]; then
  # OUTPUT="${TITLE:0:$MAX_TITLE_WIDTH-1}"
  OUTPUT="${TITLE:${#OUTPUT}-$MAX_TITLE_WIDTH:${#OUTPUT}}"
  # Remove trailing spaces
  # OUTPUT="…${OUTPUT%"${OUTPUT##*[![:space:]]}"}"
  OUTPUT="<${OUTPUT%"${OUTPUT##*[![:space:]]}"}"
fi

# Calculate the progress bar for sane durations
# This consume cpu and battery because the refresh interval,
# is not recomended refresh the status bar in short time spaces.
# if [ -n "$DURATION" ] && [ -n "$POSITION" ] && [ "$DURATION" -gt 0 ] && [ "$DURATION" -lt 3600 ]; then
# POSITION="021020"
# DURATION=%M:%S
# TIME="[$(date -d@$POSITION -u +%M:%S)/$(date -d@$DURATION -u +%M:%S)]"
# TIME_AUX="$(echo $($(date -d@$POSITION +%s) - $(date -d@$DURATION +%s)))"
# TIME_AUX="$(echo $(( ($(date -date="031122" +%s) - $(date --date="021020" +%s) )/(60*60*24) )) )"
# TIME_AUX="$(echo $(( ($(date --date="031122" +%s) - $(date --date="021020" +%s) )/(60*60*24) +1)) )"

# echo "#[fg=blue,bg=default]░  ${RESET}#[bg=default]${current_path} "
echo "#[fg=blue,bg=default]░  ${RESET}#[bg=default]$OUTPUT"
