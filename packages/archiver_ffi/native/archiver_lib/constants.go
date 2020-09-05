package main

import "os"

var (
	GlobalPatternDenylist = []string{"pax_global_header", "__MACOSX/*", "*.DS_Store"}
	PathSep               = string(os.PathSeparator)
)
