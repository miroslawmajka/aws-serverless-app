#!/usr/bin/env bash

echo "Determining if $1 workspace exists..."

if [ $(terraform workspace list | grep -c "$1") -eq 0 ] ; then
  echo "Creating new $1 workspace..."
  terraform workspace new "$1" -no-color
else
  echo "Selecting existing $1 workspace..."
  terraform workspace select "$1" -no-color
fi
