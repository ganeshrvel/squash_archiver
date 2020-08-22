package main

import "os"

var (
	FileDenylist = []string{"pax_global_header"}
	PathSep      = string(os.PathSeparator)
)
