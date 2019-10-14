#!/bin/bash
source "$MODULAR_BASHING_BIN_DIR/setup.shell"

has_first_param() {
  if [ "$1" == "" ];
  then
    echo "false"
  else
    echo "true"
  fi
}

is_command_name_available() {
  command_name="$1"
  if [ "$(ls $MODULAR_BASHING_BIN_DIR | grep "^$command_name\$")" == "" ];
  then
    echo "true"
  else
    echo "false"
  fi
}

has_valid_params() {
  if [ "$(has_first_param "$@")" == "true" ] && [ "$(is_command_name_available "$@")" == "true" ];
  then
    echo "true"
  else
    echo "false"
  fi
}

handle_has_valid_params() {
  command_name="$1"
  touch "$command_name"
  echo "#!/bin/bash" >> "$command_name"
  echo "source \$MODULAR_BASHING_BIN_DIR/setup.shell" >> "$command_name"
  echo "shopt -s expand_aliases" >> "$command_name"
  chmod +x "$command_name"
  ln "$command_name" "$MODULAR_BASHING_BIN_DIR/$command_name"
  editor "$command_name"
}

handle_does_not_have_first_param() {
  echo "1st parameter needs to be name of command you want created"
}

handle_command_name_not_available() {
  command_name="$1"
  echo "command name, $command_name, already in use"
}

handle_unseen_condition() {
  echo "unaccounted unseen condition in code"
}

run_script() {
  if [ "$(has_valid_params "$@")" == "true" ];
  then
    handle_has_valid_params "$@"
  elif [ "$(has_first_param "$@")" == "false" ];
  then
    handle_does_not_have_first_param
  elif [ "$(is_command_name_available "$@")" == "false" ];
  then
    handle_command_name_not_available "$@"
  else
    handle_unseen_condition
  fi
}

run_script "$@"
