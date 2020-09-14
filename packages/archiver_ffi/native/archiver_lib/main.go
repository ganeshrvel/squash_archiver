package main

import "C"
import (
	"./dart_ffi/dart_api_dl"
	fmt "fmt"
	onearchiver "github.com/ganeshrvel/one-archiver"
	"unsafe"
)

/*
#include "stdlib.h"
#include "stdint.h"
#include "stdio.h"
*/
import "C"

//export InitNewNativeDartPort
func InitNewNativeDartPort(api unsafe.Pointer) {
	dart_api_dl.InitializeDartApi(api)
}

//export CloseNativeDartPort
func CloseNativeDartPort(port int64) bool {
	return dart_api_dl.CloseNativePort(port)
}

//export ListArchive
func ListArchive(port int64, filename, password, orderBy, orderDir, listDirectoryPath *C.char, gitIgnorePatternAddr int64, recursive bool) {
	var err error
	var result []onearchiver.ArchiveFileInfo

	_filename := C.GoString(filename)
	_password := C.GoString(password)
	_orderBy := C.GoString(orderBy)
	_orderDir := C.GoString(orderDir)
	_listDirectoryPath := C.GoString(listDirectoryPath)

	dart_api_dl.GetGitIgnorePattern(gitIgnorePatternAddr)

	if exist := onearchiver.FileExists(_filename); !exist {
		err = fmt.Errorf("file does not exist: %v\n", _filename)
	} else {
		meta := &onearchiver.ArchiveMeta{Filename: _filename, Password: _password /*, GitIgnorePattern:*/}

		var ob onearchiver.ArchiveOrderBy

		switch _orderBy {
		case "size":
			ob = onearchiver.OrderBySize

			break

		case "modTime":
			ob = onearchiver.OrderByModTime

			break

		case "name":
			ob = onearchiver.OrderByName

			break

		case "fullPath":
			ob = onearchiver.OrderByFullPath

			break
		}

		var od onearchiver.ArchiveOrderDir
		switch _orderDir {
		case "asc":
			od = onearchiver.OrderDirAsc
			break

		case "desc":
			od = onearchiver.OrderDirDesc

			break

		case "none":
			od = onearchiver.OrderDirNone

			break
		}

		read := &onearchiver.ArchiveRead{
			ListDirectoryPath: _listDirectoryPath,
			Recursive:         recursive,
			OrderBy:           ob,
			OrderDir:          od,
		}

		result, err = onearchiver.GetArchiveFileList(meta, read)
	}

	dart_api_dl.SendArchiveListing(port, err, &result)
}

//export FreeListArchiveMemory
func FreeListArchiveMemory(ptrAddr int64) {
	dart_api_dl.FreeListArchiveMemory(ptrAddr)
}

//export IsArchiveEncrypted
func IsArchiveEncrypted() {

}

//export Pack
func Pack() {

}

//export Unpack
func Unpack() {

}

// Unused
func main() {}
