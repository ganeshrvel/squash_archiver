package main

import (
	"fmt"
	"github.com/yeka/zip"
)

//export ListArchive
func ListArchive() {
	filename := getDesktopFiles("test.zip")

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist: %s\n", filename)

		return
	}

	_metaObj := &ArchiveMeta{filename: filename}

	_listObj := &ArchiveRead{
		password:          "",
		listDirectoryPath: "phayes-geoPHP-6855624/",
		recursive:         true,
		orderBy:           OrderByName,
		orderDir:          OrderDirAsc,
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
	filename := getDesktopFiles("test.enc.zip")

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

//export Pack
func Pack() {
	filename := getDesktopFiles("12345.pack.zip")
	path1 := getDesktopFiles("test")
	path2 := getDesktopFiles("openmtp/dll")

	_metaObj := &ArchiveMeta{filename: filename}

	_packObj := &ArchivePack{
		password:          "",
		fileList:          []string{path1, path2},
		gitIgnorePattern:  "",
		encryptionMethod:  zip.StandardEncryption,
		overwriteExisting: true,
	}

	err := startPacking(_metaObj, _packObj)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", "Success")
}

// Unused
func main() {
	//ListArchive()
	//IsArchiveEncrypted()
	//Pack()
}
