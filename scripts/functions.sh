#!/usr/bin/env bash
# shellcheck disable=SC2034
# --------------------------------------------------------------------------------------------------
# ==================================================================================================
# ==================================================================================================
# **************************************************************************************************
#
#  88888888888  88        88  888b      88    ,ad8888ba,    ad88888ba
#  88           88        88  8888b     88   d8"'    `"8b  d8"     "8b
#  88           88        88  88 `8b    88  d8'            Y8,
#  88aaaaa      88        88  88  `8b   88  88             `Y8aaaaa,
#  88"""""      88        88  88   `8b  88  88               `"""""8b,
#  88           88        88  88    `8b 88  Y8,                    `8b
#  88           Y8a.    .a8P  88     `8888   Y8a.    .a8P  Y8a     a8P
#  88            `"Y8888Y"'   88      `888    `"Y8888Y"'    "Y88888P"
#
# ==================================================================================================
# A place to put all of the shell functions.
# ==================================================================================================

#######################################
# Convert string to lowercase
# Arguments:
#   1 - String to convert
# Returns:
#   lowercase string
#######################################
lowercase () {
  echo "${1:-}" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

#######################################
# Load environment variables from file
# Arguments:
#   1 - Path to env-var file
# Returns:
#   None
#######################################
load_vars () {
  [[ -e "${1:-}" ]] && {
    echo "Loading '${1}' variables"
    VAR_LOADER_SAVED_OPTS=$(set +o)
    set -o allexport
    # shellcheck disable=SC1090,SC1091
    [[ -f "$1" ]] && . "$1"
    set +o allexport
    eval "$VAR_LOADER_SAVED_OPTS"
    unset VAR_LOADER_SAVED_OPTS
  }
}

#######################################
# Run Terraform tasks (commands)
# on provided module directories.
# Gobals:
#   terraform
# Arguments:
#   1 - base path where your Terraform Modules are kept
#   2 - directory of your Terraform Module (relative to base path)
#   3 - "Task" to run; [default] = test | apply | destroy
# Returns:
#   None
#######################################
run_terraform () {
  if [[ -z "${1:-}" ]]; then
    echo "arg[1] - {{TERRAFORM_BASE_PATH}} is required, base path where your Terraform Modules are kept"
    exit 2
  fi
  TERRAFORM_BASE_PATH="${1}"
  if [[ ! -d "${TERRAFORM_BASE_PATH}" ]]; then
    echo "arg[1] - {{TERRAFORM_BASE_PATH}} ! Error; path was not found"
    exit 2
  fi
  if [[ -z "${2:-}" ]]; then
    echo "arg[2] - {{TERRAFORM_MODULE_DIR}} is required, directory of your Terraform Module (relative to base path)"
    exit 2
  fi
  TERRAFORM_MODULE_DIR="${2}"
  if [[ ! -d "${TERRAFORM_BASE_PATH}/${TERRAFORM_MODULE_DIR}" ]]; then
    echo "arg[2] - {{TERRAFORM_MODULE_DIR}} ! Error; path was not found"
    exit 2
  fi
  TERRAFORM_MODULE_TASK="${3:test}"
  if [[ "$TERRAFORM_MODULE_TASK" = "apply" ]]; then
    (
      cd "${TERRAFORM_BASE_PATH}/${TERRAFORM_MODULE_DIR}" || exit;
      echo "Running 'terraform init' on module; ${TERRAFORM_MODULE_DIR}"
      terraform init
      echo "Running 'terraform apply' on module; ${TERRAFORM_MODULE_DIR}"
      if terraform apply -auto-approve; then
        : # Successful
        # TODO: Git-commit updated Terraform state file.
      else
        echo "run_terraform (${TERRAFORM_MODULE_DIR}) $TERRAFORM_MODULE_TASK: ! Error while running 'terraform apply'"
        exit 2
      fi
    )
  elif [[ "$TERRAFORM_MODULE_TASK" = "destroy" ]]; then
    (
      cd "$TERRAFORM_PATH/${TERRAFORM_MODULE_DIR}" || exit;
      echo "Running 'terraform destroy' on module; ${TERRAFORM_MODULE_DIR}"
      if terraform destroy -auto-approve; then
        : # Successful
      else
        echo "run_terraform (${TERRAFORM_MODULE_DIR}) $TERRAFORM_MODULE_TASK: ! Error while running 'terraform destroy'"
        exit 2
      fi
    )
  else
    (
      cd "${TERRAFORM_BASE_PATH}/${TERRAFORM_MODULE_DIR}" || exit;
      echo "Running terraform init on module; ${TERRAFORM_MODULE_DIR}"
      if terraform init; then
        : # Successful
      else
        echo "run_terraform (${TERRAFORM_MODULE_DIR}) $TERRAFORM_MODULE_TASK: ! Error while running 'terraform init ${TERRAFORM_MODULE_DIR}'"
        exit 2
      fi
      echo "Running terraform validate on module; ${TERRAFORM_MODULE_DIR}"
      if terraform validate; then
        : # Successful
      else
        echo "run_terraform (${TERRAFORM_MODULE_DIR}) $TERRAFORM_MODULE_TASK: ! Error while running 'terraform validate ${TERRAFORM_MODULE_DIR}'"
        exit 2
      fi
      echo "Running terraform plan on module; ${TERRAFORM_MODULE_DIR}"
      if terraform plan; then
        : # Successful
      else
        echo "run_terraform (${TERRAFORM_MODULE_DIR}) $TERRAFORM_MODULE_TASK: ! Error while running 'terraform plan ${TERRAFORM_MODULE_DIR}'"
        exit 2
      fi
    )
  fi
  echo "run_terraform (${TERRAFORM_MODULE_DIR}) $TERRAFORM_MODULE_TASK: Completed with success!"
}

#######################################
# Run sonar-scanner
# Gobals:
#   sonar-scanner
# Arguments:
#   1 - Path of directory containing sonar-project.properties file
#   2 - [optional] Sonar Host URL (-Dsonar.host.url)
# Returns:
#   None
#######################################
run_sonar_scanner () {
  if [[ -z "${1:-}" ]]; then
    echo "arg[1] - {{SONAR_PROJECT_PATH}} is required, path of directory containing sonar-project.properties file"
    exit 2
  fi
  SONAR_PROJECT_PATH="${1}"
  if [[ ! -d "${SONAR_PROJECT_PATH}" ]]; then
    echo "arg[1] - {{SONAR_PROJECT_PATH}} ! Error; path was not found"
    exit 2
  fi
  if [[ ! -e "${SONAR_PROJECT_PATH}/sonar-project.properties" ]]; then
    echo "run_sonar_scanner: ! Error; sonar-project.properties file was not found"
    exit 2
  fi
  if ! type "sonar-scanner" &> /dev/null; then
    echo "run_sonar_scanner: ! Error; 'sonar-scanner' not found in PATH"
    exit 2
  fi
  SONAR_SERVER_URL="${2:-}"
  [[ -z "${SONAR_SERVER_URL}" ]] && SONAR_SERVER_URL="https://sonarcloud.io"
  echo "SONAR script started"
  SONAR_CMD="sonar-scanner"
  if [[ -z "${SONAR_SERVER_URL:-}" ]]; then
    SONAR_CMD="sonar-scanner -Dsonar.host.url=$SONAR_SERVER_URL"
  fi
  if "$SONAR_CMD"; then
    : # Successful
  else
    echo "run_sonar_scanner: ! Error while running 'sonar-scanner'"
    exit 2
  fi
  echo "run_sonar_scanner: Completed with success!"
}

#######################################
# Run codecov.io
# Gobals:
#   bash
#   curl
# Arguments:
#   1 - Path of directory containing sonar-project.properties file
#   2 - [optional] Sonar Host URL (-Dsonar.host.url)
# Returns:
#   None
#######################################
run_codecov () {
  if [[ -z "${1:-}" ]]; then
    echo "arg[1] - {{PROJECT_PATH}} is required, path of directory containing sonar-project.properties file"
    exit 2
  fi
  PROJECT_PATH="${1}"
  if [[ ! -d "${PROJECT_PATH}" ]]; then
    echo "arg[1] - {{PROJECT_PATH}} ! Error; path was not found"
    exit 2
  fi
  if [[ -z "${CODECOV_TOKEN:-}" ]]; then
    echo "run_codecov: ! Error; 'CODECOV_TOKEN' variable was not found or was empty"
    exit 2
  fi
  if ! type "bash" &> /dev/null; then
    echo "run_codecov: ! Error; 'bash' not found in PATH"
    exit 2
  fi
  if ! type "curl" &> /dev/null; then
    echo "run_codecov: ! Error; 'curl' not found in PATH"
    exit 2
  fi
  echo "Running codecov.io script"
  (
    cd "${PROJECT_PATH}" || exit
    if bash <(curl -s https://codecov.io/bash); then
      : # Successful
    else
      echo "run_codecov: ! Error while running 'bash <(curl -s https://codecov.io/bash)'"
      exit 2
    fi
  )
  echo "run_codecov: Completed with success!"
}

