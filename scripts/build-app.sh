#!/usr/bin/env bash

flutter clean

flutter build macos --release

open ./build/macos/Build/Products/Release
