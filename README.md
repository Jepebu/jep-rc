# horizon-rc
horizon-rc is a small collection of shell configuration files for zsh and bash which make development a bit easier.

## Install
To replace your current shell configurations, follow these two steps:  
1. Clone the repository
```
git clone https://github.com/mbragg-spear/horizon-rc.git
cd horizon-rc
```

2. Run the installation
```
./install.sh
```

For a partial integration, you can cherry pick whichever parts of the configuration files you like and add them to your own.


## Features
The full set of shell files includes a few functions and aliases that I've found to be useful during development, as well as prompt configurations that provide an informative snapshot of a few different things.

### Prompt
#### Git Branch Status
When inside a git repo directory, the shell prompt will include a line that displays the current branch status.  
This includes:
- Branch name
- Tracked/Untracked/Staged files (denoted by color)
  - Green:   Default - no changes in branch since last commit
  - Yellow:  Staged but uncommited changes
  - Red:     Unstaged and uncommited changes
  - Magenta: Default for specifically the 'main' branch
- The number of commits your local branch is ahead of/behind the remote branch

This is how it looks for a branch that is 23 commits behind and 12 commits ahead of the remote branch.  
```
[mbragg/hzn-1094-add-max-pixel-to-bearing-time-record-specification ↓23↑12]
matthewbragg@Matthews-MacBook-Air horizon %
```

#### Command Return Status
After executing any command, the return/exit code is evaluated for failure.  
Anything other than 0 will change the prompt character (Default % for zsh, $ for bash) from green to red.

#### Command Execution Time
After executing any command that takes longer than one second to complete, the execution time will be display in the prompt.  
Please note that execution times may be slow by up to 1 second.  

For `zsh` the time is display in `$RPROMPT`.
```
matthewbragg@Matthews-MacBook-Air ~ % sleep 5
matthewbragg@Matthews-MacBook-Air ~ %                                                          5s
```
For `bash` the time is displayed just before the prompt character.
```
matthewbragg@Matthews-MacBook-Air ~ $ sleep 5
matthewbragg@Matthews-MacBook-Air ~ 5s $
```

### Functions/Aliases
The most notable functions and aliases can be found in your respective shell's `~/.horizon_(ba|z)shrc` file.  
Below is an incomplete list of the definitions within the shell files.

#### Specific to Horizon
- `nuke-sql`
  - Destructively resets the Horizon database.
- `reset-docker-storage`
  - Wipes out persistent Docker storage volumes and containers so prevent cross-over between git branches.
- `hzn-switch`
  - Calls `git switch` on the branch matching `*/hzn-$1-*`.
- `exe-sql`
  - Executes the contents of the file provided in `$1` on the Horizon database.
- `dev-nuke-all (--reset)`
  - Completely wipes `$HORIZON_DIR` and all Docker containers/volumes, with the option `--reset` re-cloning Horizon and running `pnpm install`.

#### General use
- `pgrep`
  - Wrapper function for MacOS built-in `pgrep` which uses `ps` to provide more detailed process information.
