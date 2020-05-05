config_general() {
  log_and_run
}

function log_info {
  echo "---> `date +%T`     $@"
}

function log_and_run {
  log_info "Running $@"
  "$@"
}


