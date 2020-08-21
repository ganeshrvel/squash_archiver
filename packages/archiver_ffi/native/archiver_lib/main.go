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

	_metaObj := &ArchiveMeta{filename: filename}

	_listObj := &ArchiveList{
		password:          "",
		listDirectoryPath: "phayes-geoPHP-6855624/",
		recursive:         false,
		orderby:           "",
		orderByDir:        "",
	}

	result, err := getArchiveFileList(_metaObj, _listObj)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", result)

}

//export IsArchiveEncrypted
func IsArchiveEncrypted() {
	_home, _ := homedir.Dir()

	filename := fmt.Sprintf("%s/Desktop/test.enc.zip", _home)

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist %s\n", filename)

		return
	}

	_metaObj := &ArchiveMeta{filename: filename}

	result, err := isArchiveEncrypted(_metaObj)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", result)

}

// Unused
func main() {
	ListArchive()
	//IsArchiveEncrypted()
}
