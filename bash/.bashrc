####################
### PATH Entries ###
####################

# User's bin executable folder(s) - prepended to search here before anywhere else
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]]        && PATH="$HOME/bin:$PATH"

# Add PATH entries from your package manager (homebrew, apt, dnf, yum) to this file
[[ -f "$HOME/.pkg_mgr_paths" ]] && source "$HOME/.pkg_mgr_paths"

PATH=$(echo "$PATH" | awk -v RS=: '!seen[$0]++ {if (NR > 1) printf(":"); printf("%s", $0)}') # Ensures that all PATH entries are unique
export PATH


###################################
### Non-Interactive Shell Guard ###
###################################

[[ $- == *i* ]] || return 0 # Prevents further configurations in non-interactive shells, such as during script execution.


#####################
### Shell Options ###
#####################

shopt -s cdspell  # Will automatically fix small mistakes in directory names when using 'cd'
shopt -s dotglob  # Will include dot files (Ex .bashrc) in filename expansion
shopt -s extglob  # Enabled extended pathname expansion such as !(pattern) and @(pattern)


#############################
### Environment Variables ###
#############################

# CURRENT_SHELL helps us determine what shell we're currently in (bash/zsh/csh)
export CURRENT_SHELL=$(which bash)

# LANG variables for terminal output
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export GPG_TTY=$(tty) # For git commit signing

# ANSI box drawing characters
export VERTICAL='│'
export HORIZONTAL='─'
export TOP_LEFT='┌'
export TOP_RIGHT='┐'
export BOTTOM_LEFT='└'
export BOTTOM_RIGHT='┘'


###############
### Aliases ###
###############

### Builtin Overrides (personal preference)
alias ls="ls -a --color='always'"
alias c='clear'
# Commented out by default due to it being a Homebrew installation - use 'brew install egrep' and uncomment to enable the alias
# alias grep='egrep' # Replace MacOS builtin grep with Homebrew egrep

### Git aliases
alias current-branch="git branch --list | grep '\*' | awk '{print \$2}'"
alias bl='git branch --list'


#################
### Functions ###
#################

### Personal pgrep wrapper
# Displays each process with more detailed information
# than what MacOS pgrep has the capabilities for.

# Always reset $__ORIGINAL_PGREP__ to make sure we have the newest executable in $PATH
typeset -f pgrep >/dev/null && unset -f pgrep
__ORIGINAL_PGREP__=$(which pgrep)

pgrep() {

  PIDS=$($__ORIGINAL_PGREP__ $@ | awk '{print $1}')
  [[ "$PIDS" ]] || return 1

  ps -o 'pid user etime command' -p ${=PIDS} | less -Fn

}

#####################
### Extra Configs ###
#####################

# Config for Horizon development
. $HOME/.horizon_bashrc

###################################
### Basic Prompt Configurations ###
###################################

### Incomplete guide to prompt configuration options
# \u: Username.
# \h: Hostname (short).
# \w: Current working directory, with home directory abbreviated by a tilde ~.
# \W: Abbreviated current working directory.
# \t or \T: Current time (24 or 12 hour format).

# Color codes:
# - Black:        \e[30m \[\e[30m\]
# - Red:          \e[31m \[\e[31m\]
# - Green:        \e[32m \[\e[32m\]
# - Yellow:       \e[33m \[\e[33m\]
# - Blue:         \e[34m \[\e[34m\]
# - Magenta:      \e[35m \[\e[35m\]
# - Cyan:         \e[36m \[\e[36m\]
# - White:        \e[37m \[\e[37m\]
# Format codes:
# - Bold:         \e[1m  \[\e[1m\]
# - Italic:       \e[3m  \[\e[3m\]
# - Underline:    \e[4m  \[\e[4m\]
# Other:
# - Reset format: \e[0m  \[\e[0m\]

### Default bash prompt
### Ex. matthewbragg@Matthews-MacBook-Air ~ $
# PS1="\u@\h \w \$ "

### Default bash prompt + color
### Ex. Same as above but with color
PS1="\[\e[34m\]\u@\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\] \$ "

######################################
### Advanced Prompt Configurations ###
######################################

source $HOME/.bash_prompt/git_status # Display git branch stats on line above prompt
source $HOME/.bash_prompt/exe_time   # Display last command execution time
source $HOME/.bash_prompt/exe_status # Display the last command return status
