package main

import (
	"fmt"
	"github.com/mitchellh/go-homedir"
)

//export ListArchive
func ListArchive() {
	_home, _ := homedir.Dir()

	GetArchiveFileList(fmt.Sprintf("%s/Desktop/test.tar.gz", _home), "", "")
}

// Unused
func main() {
	ListArchive()
}
