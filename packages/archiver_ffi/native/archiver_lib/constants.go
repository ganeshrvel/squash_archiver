package main

import "os"

var (
	FileDenylist = [1]string{"pax_global_header"}
	PathSep      = string(os.PathSeparator)
)
