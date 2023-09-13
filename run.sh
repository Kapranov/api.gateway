#!/usr/bin/env bash


echo -e "\n\n\033[1;32m Start Server and Console\033[0;0m: \033[1;31m159.224.174.183\033[0;0m:\033[1;36;44m4000/graphiql\033[0;0m\n"

mix deps.clean gateway --build
sleep 3s
mix compile
sleep 5s
clear
iex -S mix phx.server
