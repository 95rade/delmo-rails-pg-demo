#!/bin/bash

set -x

[[ "$(rake db:version 2>/dev/null)X" != "X" ]] && (
  echo db still running
  exit 1
)
echo db cannot be accessed... good.
exit 0
