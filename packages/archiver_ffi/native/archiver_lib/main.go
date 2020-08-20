package main

import (
	"fmt"
	"github.com/mitchellh/go-homedir"
)

//export ListArchive
func ListArchive() {
	_home, _ := homedir.Dir()

	result, err := getArchiveFileList(fmt.Sprintf("%s/Desktop/test.zip", _home), "", "phayes-geoPHP-6855624/", true)

	if err != nil {
		fmt.Printf("Error occured: %+v", err)

		return
	}

	fmt.Printf("Result: %+v", result)

}

// Unused
func main() {
	ListArchive()
}
