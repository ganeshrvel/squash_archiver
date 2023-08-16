package main

import "C"
import (
	"fmt"
	onearchiver "github.com/ganeshrvel/one-archiver"
	zip "github.com/ganeshrvel/yeka_zip"
	"unsafe"
)

//export InitNewNativeDartPort
func InitNewNativeDartPort(api unsafe.Pointer) {
	DartApiInitializeDart(api)
}

//export CloseNativeDartPort
func CloseNativeDartPort(port int64) bool {
	return DartApiCloseNativePort(port)
}

//export ListArchive
func ListArchive(port int64, filename, password, orderBy, orderDir, listDirectoryPath *C.char, gitIgnorePatternPtrAddr int64, recursive bool) {
	var err error
	var result []onearchiver.ArchiveFileInfo

	_filename := string(C.GoString(filename))
	_password := string(C.GoString(password))
	_orderBy := string(C.GoString(orderBy))
	_orderDir := string(C.GoString(orderDir))
	_listDirectoryPath := string(C.GoString(listDirectoryPath))
	_gitIgnorePattern := DartApiGetStringList(gitIgnorePatternPtrAddr)

	if exist := onearchiver.FileExists(_filename); !exist {
		err = fmt.Errorf("file does not exist: %s\n", _filename)
	} else {
		meta := &onearchiver.ArchiveMeta{Filename: _filename, Password: _password, GitIgnorePattern: _gitIgnorePattern}

		var ob onearchiver.ArchiveOrderBy

		switch _orderBy {
		case "size":
			ob = onearchiver.OrderBySize

		case "modTime":
			ob = onearchiver.OrderByModTime

		case "name":
			ob = onearchiver.OrderByName

		case "fullPath":
			ob = onearchiver.OrderByFullPath
		}

		var od onearchiver.ArchiveOrderDir
		switch _orderDir {
		case "asc":
			od = onearchiver.OrderDirAsc

		case "desc":
			od = onearchiver.OrderDirDesc

		case "none":
			od = onearchiver.OrderDirNone
		}

		read := &onearchiver.ArchiveRead{
			ListDirectoryPath: _listDirectoryPath,
			Recursive:         recursive,
			OrderBy:           ob,
			OrderDir:          od,
		}

		result, err = onearchiver.GetArchiveFileList(meta, read)
	}

	DartApiSendArchiveListing(port, err, &result)
}

//export FreeListArchiveMemory
func FreeListArchiveMemory(ptrAddr int64) {
	DartApiFreeListArchiveMemory(ptrAddr)
}

//export IsArchiveEncrypted
func IsArchiveEncrypted(port int64, filename, password *C.char) {
	_filename := string(C.GoString(filename))
	_password := string(C.GoString(password))

	var err error
	var result onearchiver.EncryptedArchiveInfo

	if exist := onearchiver.FileExists(_filename); !exist {
		err = fmt.Errorf("file does not exist %s", _filename)
	} else {
		am := &onearchiver.ArchiveMeta{
			Filename: _filename,
			Password: _password,
		}

		result, err = onearchiver.IsArchiveEncrypted(am)
	}

	DartApiSendIsArchiveEncrypted(port, err, &result)
}

//export FreeIsArchiveEncryptedMemory
func FreeIsArchiveEncryptedMemory(ptrAddr int64) {
	DartApiFreeIsArchiveEncryptedMemory(ptrAddr)
}

//export PackFiles
func PackFiles(port int64, filename, password *C.char, gitIgnorePatternPtrAddr int64, fileListPtrAddr int64) {
	_filename := string(C.GoString(filename))
	_password := string(C.GoString(password))

	am := &onearchiver.ArchiveMeta{
		Filename:         _filename,
		Password:         _password,
		GitIgnorePattern: DartApiGetStringList(gitIgnorePatternPtrAddr),
		EncryptionMethod: zip.StandardEncryption,
	}

	ap := &onearchiver.ArchivePack{
		FileList: DartApiGetStringList(fileListPtrAddr),
	}

	var _pInfo onearchiver.ProgressInfo
	ph := &onearchiver.ProgressHandler{
		OnReceived: func(pInfo *onearchiver.ProgressInfo) {
			DartApiSendPackFiles(port, nil, pInfo, false)
			_pInfo = *pInfo
		},
		OnError: func(err error, pInfo *onearchiver.ProgressInfo) {
			DartApiSendPackFiles(port, err, pInfo, false)
			_pInfo = *pInfo
		},
		OnCompleted: func(pInfo *onearchiver.ProgressInfo) {
			DartApiSendPackFiles(port, nil, pInfo, false)
			_pInfo = *pInfo
		},
	}

	err := onearchiver.StartPacking(am, ap, ph)

	DartApiSendPackFiles(port, err, &_pInfo, true)
}

//export FreePackFilesMemory
func FreePackFilesMemory(ptrAddr int64) {
	DartApiFreePackFilesMemory(ptrAddr)
}

//export UnpackFiles
func UnpackFiles(port int64, filename, password, destination *C.char, gitIgnorePatternPtrAddr int64, fileListPtrAddr int64) {
	_filename := string(C.GoString(filename))
	_password := string(C.GoString(password))
	_destination := string(C.GoString(destination))

	am := &onearchiver.ArchiveMeta{
		Filename:         _filename,
		Password:         _password,
		GitIgnorePattern: DartApiGetStringList(gitIgnorePatternPtrAddr),
		EncryptionMethod: zip.StandardEncryption,
	}

	au := &onearchiver.ArchiveUnpack{
		FileList:    DartApiGetStringList(fileListPtrAddr),
		Destination: _destination,
	}

	var _pInfo onearchiver.ProgressInfo
	ph := &onearchiver.ProgressHandler{
		OnReceived: func(pInfo *onearchiver.ProgressInfo) {
			DartApiSendUnpackFiles(port, nil, pInfo, false)
			_pInfo = *pInfo
		},
		OnError: func(err error, pInfo *onearchiver.ProgressInfo) {
			DartApiSendUnpackFiles(port, err, pInfo, false)
			_pInfo = *pInfo
		},
		OnCompleted: func(pInfo *onearchiver.ProgressInfo) {
			DartApiSendUnpackFiles(port, nil, pInfo, false)
			_pInfo = *pInfo
		},
	}

	err := onearchiver.StartUnpacking(am, au, ph)

	DartApiSendUnpackFiles(port, err, &_pInfo, true)
}

//export FreeUnpackFilesMemory
func FreeUnpackFilesMemory(ptrAddr int64) {
	DartApiFreeUnpackFilesMemory(ptrAddr)
}

// Unused
func main() {}
