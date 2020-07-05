#!/usr/bin/env bash

##### Flutter formatter
printf "\n"
printf "\e[33;1m%s\e[0m\n" 'Running the Dart formatter'
/usr/local/bin/dartfmt -w ./lib/


##### Flutter analyzer
printf "\n"
printf "\e[33;1m%s\e[0m\n" 'Running the Dart analyzer'
/usr/local/bin/dartanalyzer --fatal-infos --fatal-warnings ./lib/
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" 'Dart analyzer error, cannot build the app.'
  exit 1
fi
