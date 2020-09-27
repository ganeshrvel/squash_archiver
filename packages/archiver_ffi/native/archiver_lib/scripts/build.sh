#!/bin/zsh

# usage ./build.sh --no-verify

NO_VERIFY=0

# Loop through arguments and process them
for arg in "$@"
do
    case ${arg} in
        --no-verify)
        NO_VERIFY=1
        shift # Remove --initialize from processing
        ;;
    esac
done


if ((NO_VERIFY == 0)); then
	##### Go formatter
	printf "\n"
	printf "\e[33;1m%s\e[0m\n" 'Running the Go formatter'
	gofmt -l -s -w .
fi

printf "\n"
printf "\e[33;1m%s\e[0m\n" 'Buiding the library'
go build -v -o build/archiver_lib.dylib -buildmode=c-shared main.go
