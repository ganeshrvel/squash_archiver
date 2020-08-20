package main

import (
	"fmt"
	"github.com/mitchellh/go-homedir"
)

//export ListArchive
func ListArchive() {
	_home, _ := homedir.Dir()

	ReadArchive(fmt.Sprintf("%s/Desktop/test.tar.gz", _home), "", "")
}

// Unused
func main() {
	ListArchive()
}
