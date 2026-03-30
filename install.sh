#!/usr/bin/env bash

LOG_FILE=/tmp/horizon-rc.log
ERR_LOG_FILE=/tmp/horizon-rc_error.log

rm -f $LOG_FILE
rm -f $ERR_LOG_FILE

HORIZON_RC_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd)"

RANDOM_UUID=$(uuidgen)

STORAGE_DIR=$HOME/.horizon-rc/$RANDOM_UUID
mkdir -p $STORAGE_DIR

INSTALL_FILES="$HORIZON_RC_DIR/zsh/.zshrc $HORIZON_RC_DIR/zsh/.horizon_zshrc $HORIZON_RC_DIR/bash/.bashrc $HORIZON_RC_DIR/bash/.horizon_bashrc"
INSTALL_DIRS="$HORIZON_RC_DIR/zsh/.zsh_prompt $HORIZON_RC_DIR/zsh/.zsh_functions $HORIZON_RC_DIR/bash/.bash_prompt $HORIZON_RC_DIR/bash/.bash_functions"

for FILE in $INSTALL_FILES; do
  [[ -f "$HOME/$(basename $FILE)" ]] && mv "$HOME/$(basename $FILE)" "$STORAGE_DIR/$(basename $FILE)"
  cp -v $FILE "$HOME/$(basename $FILE)" >> $LOG_FILE 2>> $ERR_LOG_FILE
done

for DIR in $INSTALL_DIRS; do
  [[ -d "$HOME/$(basename $DIR)" ]] && mv "$HOME/$(basename $DIR)" "$STORAGE_DIR/$(basename $DIR)"
  cp -rv $DIR/ "$HOME/$(basename $DIR)/" >> $LOG_FILE 2>> $ERR_LOG_FILE
done


echo "Install completed!"
echo "Any existing configuration files have been moved into $STORAGE_DIR"
