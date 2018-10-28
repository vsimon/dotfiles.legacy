# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Section: More

alias more='less'


# Section: Setting the right TERM value

if [[ -z $TMUX ]]; then
   case $COLORTERM in
      (Terminal|gnome-terminal|gnome-256color|xfce4-terminal)
         TERM=gnome-256color tput colors > /dev/null 2>&1  &&  export TERM='gnome-256color'
         ;;
   esac
fi


# Section: Git

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_UNTRACKEDFILES=true
alias git-root='cd "$(git rev-parse --show-toplevel)"'
alias gs='git status'
alias gf='git fetch'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log'
alias gr='git rebase'
alias gp='git pull'
alias grom='git rebase origin/master'
alias gprune='git branch --merged master | grep -v 'master$' | xargs git branch -d'
alias gsgr='git stash && git fetch && git rebase origin/master && git stash pop'
complete -o bashdefault -o default -o nospace -F _git g
complete -o bashdefault -o default -o nospace -F _git tit

#FIXME
if [[ $(uname) = 'Linux' ]]; then
  . /usr/lib/git-core/git-sh-prompt
fi

# Section: GOPATH

export GOPATH=$HOME/Dropbox/src/gopath
export PATH=$PATH:$GOPATH/bin:$HOME/.local/bin


# Section: Prompt

ansi_color()
{
   local color
   case "$1" in
      black)        color="\e[0;30m";;
      red)          color="\e[0;31m";;
      green)        color="\e[0;32m";;
      brown)        color="\e[0;33m";;
      blue)         color="\e[0;34m";;
      purple)       color="\e[0;35m";;
      cyan)         color="\e[0;36m";;
      light_gray)   color="\e[0;37m";;
      dark_gray)    color="\e[1;30m";;
      light_red)    color="\e[1;31m";;
      light_green)  color="\e[1;32m";;
      yellow)       color="\e[1;33m";;
      light_blue)   color="\e[1;34m";;
      light_purple) color="\e[1;35m";;
      light_cyan)   color="\e[1;36m";;
      white)        color="\e[1;37m";;
      none)         color="\e[0m";;
   esac
   echo "$color"
}

ansi_color256()
{
   echo "\033[38;5;$1m"
}

function theme_simple_prompt_cmd()
{
   local rc=${LAST_RC:-$?}
   local prompt_symbol=${PROMPT_SYMBOL:-"\h:\w $(__git_ps1 "(%s)")\$"}
   local color=yellow
   [[ $rc -ne 0 && $rc -ne 130 ]] && color=light_red
   PS1="\[$(ansi_color $color)\]$prompt_symbol\[$(ansi_color none)\] "
}

theme_simple()
{
   BASH_THEME_CMD=theme_simple_prompt_cmd
}
# }}}

theme_simple

function prompt_command()
{
   # As the first command, capture all status info from the previous command IN
   # ONE GO. Then later break it down. If done in two separate assignments, the
   # status of the first assignment, and not that of the previos shell command,
   # will be used instead.
   local status_capture=( $? "${PIPESTATUS[@]}" )
   LAST_RC="${status_capture[0]}"
   LAST_PIPESTATUS=( "${status_capture[@]:1}" )

   if [[ -n $BASH_THEME_CMD ]]; then
      eval "$BASH_THEME_CMD"
   fi
   log_bash_persistent_history
}

export PROMPT_COMMAND=prompt_command


# Section: History

# HISTCONTROL
# ===========
# A colon-separated list of values controlling how commands are saved on the
# history list. If the list of values includes ignorespace, lines which begin
# with a space character are not saved in the history list. A value of
# ignoredups causes lines matching the previous history entry to not be saved.
# A value of ignoreboth is shorthand for ignorespace and ignoredups. A value of
# erasedups causes all previous lines matching the current line to be removed
# from the history list before that line is saved. Any value not in the above
# list is ignored. If HISTCONTROL is unset, or does not include a valid value,
# all lines read by the shell parser are saved on the history list, subject to
# the value of HISTIGNORE. The second and subsequent lines of a multi-line
# compound command are not tested, and are added to the history regardless of
# the value of HISTCONTROL.
HISTCONTROL=ignorespace

# HISTSIZE
# ========
# The number of commands to remember in the command history. The default value
# is 500.
HISTSIZE=10000

# HISTFILESIZE
# ============
# The maximum number of lines contained in the history file. When this variable
# is assigned a value, the history file is truncated, if necessary, by removing
# the oldest entries, to contain no more than that number of  lines. The
# default value is 500. The history file is also truncated to this size after
# writing it when an interactive shell exits.
HISTFILESIZE=50000

# HISTIGNORE
# ==========
# A colon-separated list of patterns used to decide which command lines should
# be saved on the history list. Each pattern is anchored at the beginning of
# the line and must match the complete line (no implicit `*' is appended). Each
# pattern is tested against the line after the checks specified by HISTCONTROL
# are applied. In addition to the normal shell pattern matching characters, `&'
# matches the previous history line. `&' may be escaped using a backslash; the
# backslash is removed before attempting a match. The second and subsequent
# lines of a multi-line compound command are not tested, and are added to the
# history regardless of the value of HISTIGNORE.
HISTIGNORE="cd:cd *:cdd *:"

# HISTTIMEFORMAT
# ==============
# If this variable is set and not null, its value is used as a format string
# for strftime(3) to print the time stamp associated with each history entry
# displayed by the history builtin.  If this variable is set, time stamps are
# written to the history file so they may be preserved across shell sessions.
# This uses the history comment character to distinguish timestamps from other
# history lines.
HISTTIMEFORMAT="%Y-%m-%d %T %z "

# shopt: histappend
# =================
# If set, the history list is appended to the file named by the value of the
# HISTFILE variable when the shell exits, rather than overwriting the file.
shopt -s histappend


# Section: Bash Options

# checkwinsize
# ------------
#
# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize

# cdspell
# -------
#
# If set, minor errors in the spelling of a directory component in a cd command
# will be corrected. The errors checked for are transposed characters, a
# missing character, and a character too many. If a correction is found, the
# corrected path is printed, and the command proceeds. This option is only used
# by interactive shells.
shopt -s cdspell

# extglob
# -------
#
# If set, several extended pattern matching operators are recognized:
#   ?(pattern-list) Matches zero or one occurrence of the given patterns
#   *(pattern-list) Matches zero or more occurrences of the given patterns
#   +(pattern-list) Matches one or more occurrences of the given patterns
#   @(pattern-list) Matches one of the given patterns
#   !(pattern-list) Matches anything except one of the given patterns
shopt -s extglob

# Enable programmable completion features asynchronously
# See http://superuser.com/a/418112 for details
if [[ $(uname) = 'Linux' ]]; then
  if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    trap 'source /etc/bash_completion ; trap USR1' USR1
    { sleep 0.1 ; builtin kill -USR1 $$ ; } & disown
  fi
elif [[ $(uname) = 'Darwin' ]]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi


# Section: FZF

[ -d $HOME/.fzf/bin ] && if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.fzf/bin"
fi


# Auto-completion
# ---------------
[[ $- == *i* ]] && [ -f $HOME/.fzf/shell/completion.bash ] && source $HOME/.fzf/shell/completion.bash
[[ $- == *i* ]] && [ -f /usr/local/opt/fzf/shell/completion.bash ] && source /usr/local/opt/fzf/shell/completion.bash

# Key bindings
# ------------
[[ $- == *i* ]] && [ -f $HOME/.fzf/shell/key-bindings.bash ] && source $HOME/.fzf/shell/key-bindings.bash
[[ $- == *i* ]] && [ -f /usr/local/opt/fzf/shell/key-bindings.bash ] && source /usr/local/opt/fzf/shell/key-bindings.bash

__fzf_history__() (
  local line
  shopt -u nocaseglob nocasematch
  line=$(
    cat ~/.persistent_history |
    $(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS | \
    grep '^.*[-+][0-9][0-9][0-9][0-9]\ |\ ')
  sed 's/^.*[-+][0-9][0-9][0-9][0-9]\ |\ //' <<< "$line"
)


# Section: Autojump

# Linux
[ -f /usr/share/autojump/autojump.bash ] && source /usr/share/autojump/autojump.bash

# OSX
[ -f /usr/local/share/autojump/autojump.bash ] && source /usr/local/share/autojump/autojump.bash


# Section: Persistent History

log_bash_persistent_history()
{
   local HISTTIMEFORMAT="%Y-%m-%d %T %z "
   [[
      $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+\ [^\ ]+)\ +(.*)$
   ]]
   local date_part="${BASH_REMATCH[1]}"
   local command_part="${BASH_REMATCH[2]}"
   if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
   then
      echo "$date_part | $command_part" >> ~/.persistent_history
      export PERSISTENT_HISTORY_LAST="$command_part"
   fi
}

phack()
{
   ack "$@" ~/.persistent_history
}

phist()
{
   local n
   [[ -n $1 ]] && n="-n $1"
   tail $n ~/.persistent_history
}
