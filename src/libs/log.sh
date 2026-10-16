#!/usr/bin/env bash
################################################################################
# @file_name: log
# @version: 1.0.52
# @project_name: mflibs
# @brief: a library for logging functions
#
# @author: Jamie Dobbs (mschf)
# @author_contact: jamie.dobbs@mschf.dev
#
# @license: BSD-3 Clause (Included in LICENSE)
# Copyright (C) 2021-2022, Jamie Dobbs
# All rights reserved.
################################################################################

################################################################################
# @description: initialize log library
#   Runs every time a script loads this library, and one command can load it
#   many times (the entry script, the script it launches, nested helpers), so
#   the header and the rotation happen once per log file for a process tree:
#   the first init of a path records it in the exported mflibs_log_initialized
#   and every later init of the same path (this process or any descendant)
#   returns early, apart from re-checking that the file is still writable.
#   Rotation therefore only ever happens at the start of a run, never under a
#   writer that already has the file open.
# @env mflibs_log_location: log file path (default: <mflibs>/src/logs/<script>)
# @env mflibs_log_max_bytes: rotate at init past this size (default 5242880)
# @env mflibs_log_initialized: exported marker, the path initialised for this tree
# @return_code: 0 always, an unwritable location falls back to /tmp, then /dev/null
# @internal
################################################################################
mflibs::log::init() {
  declare mflibs_log_base;mflibs_log_base="$(dirname "$(realpath -s "${BASH_SOURCE[0]%/*}")")";
  [[ -z "${mflibs_log_location:-}" ]] && declare -g mflibs_log_location="${mflibs_log_base}/logs/${BASH_SOURCE[-1]##*/}"
  declare mflibs_log_known=0 mflibs_log_max="${mflibs_log_max_bytes:-5242880}"
  [[ "${mflibs_log_max}" =~ ^[0-9]+$ ]] || mflibs_log_max=5242880
  if [[ "${mflibs_log_initialized:-}" == "${mflibs_log_location}" ]]; then
    [[ -w "${mflibs_log_location}" ]] && return 0
    mflibs_log_known=1
  fi
  if [[ ! -d "$(dirname "${mflibs_log_location}")" ]]; then
    [[ " ${MFLIBS_LOADED[*]} " =~ verbose ]] && echo -ne "\033[38;5;44minfo\e[0m: creating log location: $(dirname "${mflibs_log_location}")\n"
    mkdir -p "$(dirname "${mflibs_log_location}")" 2>/dev/null || true
  fi
  [[ -e "${mflibs_log_location}" ]] || mflibs_log_known=0
  if ! touch "${mflibs_log_location}" 2>/dev/null; then
    # Log file not writable - try a fallback location in /tmp
    mflibs_log_location="/tmp/mflibs-${USER:-root}-${BASH_SOURCE[-1]##*/}.log"
    mflibs_log_known=0
    if ! touch "${mflibs_log_location}" 2>/dev/null; then
      # Even /tmp fallback failed - disable logging but don't exit
      [[ " ${MFLIBS_LOADED[*]} " =~ verbose ]] && echo -ne "\033[38;5;220mwarning\e[0m: logging disabled (unable to write to log file)\n"
      mflibs_log_location="/dev/null"
    fi
  fi
  if [[ ${mflibs_log_known} -eq 0 && -f "${mflibs_log_location}" && $(wc -c < "${mflibs_log_location}") -gt ${mflibs_log_max} ]]; then
    [[ " ${MFLIBS_LOADED[*]} " =~ verbose ]] && echo -ne "\033[38;5;44minfo\e[0m: rotating ${mflibs_log_location} to ${mflibs_log_location}.1\n"
    if mv -f "${mflibs_log_location}" "${mflibs_log_location}.1" 2>/dev/null; then
      # keep the owner and mode the rotated file had, a root run must not leave
      # the next writer (dashboard relay, group-writable update log) locked out
      : > "${mflibs_log_location}" 2>/dev/null || true
      chown --reference="${mflibs_log_location}.1" "${mflibs_log_location}" 2>/dev/null || true
      chmod --reference="${mflibs_log_location}.1" "${mflibs_log_location}" 2>/dev/null || true
    fi
  fi
  [[ ${mflibs_log_known} -eq 0 ]] && { printf "\n### %s ###\n" "$(date "+%Y-%m-%d %R:%S")" >> "${mflibs_log_location}" 2>/dev/null || true; }
  declare -gx mflibs_log_initialized="${mflibs_log_location}"
  [[ " ${MFLIBS_LOADED[*]} " =~ verbose ]] && echo -ne "\033[38;5;44minfo\e[0m: logging to ${mflibs_log_location}\n"
  return 0
}

################################################################################
# @description: runs and logs command
# @arg 1: command to log
# @example:
#   mflibs::log "echo hi"
################################################################################
mflibs::log() {
  #if [[ ! " ${MFLIBS_LOADED[*]} " =~ verbose ]]; then
  #  ($1 >> "${mflibs_log_location}" 2>&1)
  #else
  #  $1 |& tee -a "${mflibs_log_location}"
  #fi
  if [[ -z ${verbosity} ]]; then
    ($1 >> "${mflibs_log_location}" 2>&1)
  else
    $1 |& tee -a "${mflibs_log_location}"
  fi
}

################################################################################
# @description: runs functions in the required order
################################################################################
mflibs::log::init