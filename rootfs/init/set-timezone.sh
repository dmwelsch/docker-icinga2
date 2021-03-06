#!/bin/bash

if [ "$TIMEZONE" != "" ]; then
  echo Set TIMEZONE to $TIMEZONE
  if [ ! -e /usr/share/zoneinfo/$TIMEZONE ]; then
    >&2 echo ERROR: Could not set timezone. File /usr/share/zoneinfo/$TIMEZONE does not exist.
    exit 1
  fi
  rm /etc/localtime
  ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
else
  echo Hint: Set your timezone using TIMEZONE env var.
fi
