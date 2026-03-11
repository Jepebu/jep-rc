#!/usr/bin/env bash

LOG_FILE=/tmp/horizon-rc.log
ERR_LOG_FILE=/tmp/horizon-rc_error.log

ORIGINAL_PWD=$(pwd)

HORIZON_RC_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd)"
cd $HORIZON_RC_DIR

NEW_BRANCH=$(uuidgen)
git switch -b $NEW_BRANCH >> $LOG_FILE 2>> $ERR_LOG_FILE


INSTALL_FILES="$HORIZON_RC_DIR/zsh/.zshrc $HORIZON_RC_DIR/zsh/.horizon_zshrc $HORIZON_RC_DIR/bash/.bashrc $HORIZON_RC_DIR/bash/.horizon_bashrc"
INSTALL_DIRS="$HORIZON_RC_DIR/zsh/.zsh_prompt $HORIZON_RC_DIR/bash/.bash_prompt"

for FILE in $INSTALL_FILES; do
  [[ -f "$HOME/$(basename $FILE)" ]] && cp -v "$HOME/$(basename $FILE)" $FILE >> $LOG_FILE 2>> $ERR_LOG_FILE
done

for DIR in $INSTALL_DIRS; do
  [[ -d "$HOME/$(basename $DIR)" ]] && cp -v "$HOME/$(basename $DIR)/*" $DIR >> $LOG_FILE 2>> $ERR_LOG_FILE
done

git mergetool main || exit 1


for FILE in $INSTALL_FILES; do
  cp -v $FILE "$HOME/$(basename $FILE)" >> $LOG_FILE 2>> $ERR_LOG_FILE
done

for DIR in $INSTALL_DIRS; do
  cp -rv $DIR "$HOME/$(basename $DIR)" >> $LOG_FILE 2>> $ERR_LOG_FILE
done

git switch main >/dev/null 2>&1
git branch -D $NEW_BRANCH >/dev/null 2>&1
cd $ORIGINAL_PWD
