package main

import (
	"fmt"
	"github.com/mitchellh/go-homedir"
)

//export ListArchive
func ListArchive() {
	_home, _ := homedir.Dir()

	filename := fmt.Sprintf("%s/Desktop/test.zip", _home)

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist: %s\n", filename)

		return
	}

	result, err := getArchiveFileList(filename, "", "phayes-geoPHP-6855624/", true)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", result)

}

//export IsArchiveEncrypted
func IsArchiveEncrypted() {
	_home, _ := homedir.Dir()

	filename := fmt.Sprintf("%s/Desktop/test.tar.gz", _home)

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist %s\n", filename)

		return
	}

	result, err := isArchiveEncrypted(filename)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", result)

}

// Unused
func main() {
	//ListArchive()
	IsArchiveEncrypted()
}
