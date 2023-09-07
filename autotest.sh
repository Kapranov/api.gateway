#!/usr/bin/env bash
if [ "$1" = "--umbrella" ] || [ "$1" = "-u" ]
then
  while true; do
    inotifywait -r -e modify,move,create,delete apps/ && mix test --include integration
  done
else
  while true; do
    inotifywait -r -e modify,move,create,delete apps/core/lib/ apps/core/test/ && mix test --include integration
  done
fi
