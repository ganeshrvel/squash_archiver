#!/bin/zsh

dart run test ./test/is_archive_encrypted_test.dart --chain-stack-traces
dart run test ./test/list_archive_test.dart --chain-stack-traces
dart run test ./test/pack_files_test.dart --chain-stack-traces
dart run test ./test/unpack_files_test.dart --chain-stack-traces
