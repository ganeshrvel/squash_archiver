package main

import (
	"fmt"
	"github.com/mitchellh/go-homedir"
)

//export ListArchive
func ListArchive() {
	_home, _ := homedir.Dir()

	getArchiveFileList(fmt.Sprintf("%s/Desktop/test.tar.gz", _home), "", "phayes-geoPHP-6855624/")
}

// Unused
func main() {
	ListArchive()
}
