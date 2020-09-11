#! /bin/bash

export TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂"
export TMUX_POWERLINE_SEPARATOR_LEFT_THIN="⮃"
export TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
export TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="⮁"

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'235'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'255'}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

if [[ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"tmux_session_info 33 0" \
	)
fi

if [[ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"hostname 33 0" \
		"load 237 167" \
		"time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
	)
fi