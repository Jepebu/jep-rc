####################
### PATH Entries ###
####################

typeset -U PATH path # Keeps PATH entries unique

# User's bin executable folder(s) - prepended to search here before anywhere else
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]]        && PATH="$HOME/bin:$PATH"

# Add PATH entries from your package manager (homebrew, apt, dnf, yum) to this file
[[ -f "$HOME/.pkg_mgr_paths" ]] && source "$HOME/.pkg_mgr_paths"

export PATH


###################################
### Non-Interactive Shell Guard ###
###################################

[[ -o interactive ]] || return 0 # Prevents further configurations in non-interactive shells, such as during script execution.


#####################
### Shell Options ###
#####################

setopt CORRECTALL    # Offer corrections for minor mistakes in command / argument spelling and prompt with "[nyae]" - short for "No Yes Abort Edit"
# Ex.
# matthewbragg@Matthews-MacBook-Air zsh % cat ~/.zshc
# zsh: correct '~/.zshc' to '~/.zshrc' [nyae]?

setopt AUTO_CD       # Change into a directory if provided on the command line without 'cd'
setopt GLOB_DOTS     # Include dot files (Ex .zshrc) in filename expansion
setopt KSH_GLOB      # Enabled extended pathname expansion such as !(pattern) and @(pattern)


#############################
### Environment Variables ###
#############################

# CURRENT_SHELL helps us determine what shell we're currently in (bash/zsh/csh)
export CURRENT_SHELL=$(which zsh)

# LANG variables for terminal output
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export GPG_TTY=$(tty) # For commit signing

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

### Builtin Overrides
alias ls="ls -a --color='always'"
alias c='clear'

# Commented out by default due to it being a Homebrew installation - use 'brew install egrep' and uncomment to enable the alias
# alias grep='egrep' # Replace MacOS builtin grep with Homebrew egrep

### Git aliases
alias current-branch="git branch --show-current"
alias bl='git branch --list' # Shorthand to list git branches (bl - branch list)


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

# rustup environment config
# Commented out by default due to it being a Homebrew installation - use 'brew install rustup' and uncomment to enable the configurations
# . /opt/homebrew/opt/rustup/share/zsh/site-functions

# Config for Horizon development
. $HOME/.horizon_zshrc

###################################
### Basic Prompt Configurations ###
###################################

# Prompt Configuration Options
# %n: Username.
# %m: Hostname (short).
# %~: Current working directory, with home directory abbreviated by a tilde ~.
# %1~: The basename (last component) of the current working directory.
# %#: The prompt character (# for root, % otherwise).
# %* or %T: Current time (24-hour HH:MM:SS format).
# %F{color} / %f: Set foreground color / reset color.
# %B / %b: Start / stop bold text.
# %(?._success_._failure_): Ternary conditional based on the exit code of the last command (0 for success, non-zero for failure).

# Incomplete list of supported text formatting:
# - Colors
#   - (bright)black
#   - (bright)red
#   - (bright)green
#   - (bright)yellow
#   - (bright)blue
#   - (bright)magenta
#   - (bright)cyan
#   - (bright)white
# - Styles
#   - bold
#   - underline
#   - reverse
# - Other
#   - default (Resets to terminal's default color)


### Default zsh prompt
### Ex. matthewbragg@Matthews-MacBook-Air .zsh_prompts %
#export PROMPT="%n@%m %1~ %# "

### Default zsh prompt + color
### Ex. Same as above but with color
export PROMPT="%F{blue}%n%f@%m %F{cyan}%1~%f %# "


######################################
### Advanced Prompt Configurations ###
######################################

source $HOME/.zsh_prompt/*
# .zsh_prompt/git_status - Display git branch stats on line above prompt
# .zsh_prompt/exe_time   - Display last command execution time
# .zsh_prompt/exe_status - Display the last command return status
