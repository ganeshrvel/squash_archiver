package dart_api_dl

import "C"
import (
	"fmt"
	onearchiver "github.com/ganeshrvel/one-archiver"
	"strconv"
	"unsafe"
)

/*
#include "stdlib.h"
#include "stdint.h"
#include "stdio.h"
#include "include/dart_api_dl.c"
	// Go does not allow calling C function pointers directly. So we are
	// forced to provide a trampoline.
	bool GoDart_PostCObject(Dart_Port_DL port, Dart_CObject* obj) {
	  return Dart_PostCObject_DL(port, obj);
	}

	bool GoDart_CloseNativePort(Dart_Port_DL port) {
	  return Dart_CloseNativePort_DL(port);
	}

	typedef struct ErrorInfo{
		char *errorType;
		char *error;
	}ErrorInfo;

	typedef struct StringList{
		char **list;
		int64_t size;
	}StringList;

	// Listing
	typedef struct ArcFileInfo{
		uint32_t mode;
		int64_t size;
		bool	isDir;
		char 	*modTime;
		char 	*name;
		char 	*fullPath;
	}ArcFileInfo;

	typedef struct ArcFileInfoResult{
		ArcFileInfo **files;
		int64_t totalFiles;
		ErrorInfo *error;
	}ArcFileInfoResult;

	int64_t GetArcFileInfoResultPtr(struct ArcFileInfoResult *pResult) {
		int64_t ptr = (int64_t)pResult;

		return ptr;
	}

	void ClearListArchiveMemory(int64_t ptrAddr) {
		ArcFileInfoResult *pResult = (struct ArcFileInfoResult *) ptrAddr;

		for (int i = 0; i < pResult->totalFiles; i++) {
			free(&pResult->files[i]->mode);
		}

		free(&pResult->files);
		free(&pResult);
	}

	// Is encrypted
	typedef struct EncryptedArchiveInfo{
		bool isEncrypted;
		bool isValidPassword;
		ErrorInfo *error;
	}EncryptedArchiveInfo;

	int64_t GetEncryptedArchiveResultPtr(struct EncryptedArchiveInfo *pResult) {
		int64_t ptr = (int64_t)pResult;

		return ptr;
	}

	void ClearIsArchiveEncryptedMemory(int64_t ptrAddr) {
		EncryptedArchiveInfo *pResult = (struct EncryptedArchiveInfo *) ptrAddr;

		free(&pResult->error);
		free(&pResult);
	}

	StringList GetStringList(int64_t stringListPtrAddr) {
        StringList *p = (struct StringList *) stringListPtrAddr;

		return *p;
	}
*/
import "C"

func InitializeDartApi(api unsafe.Pointer) C.long {
	return C.Dart_InitializeApiDL(api)
}

func CloseNativePort(port int64) bool {
	result := C.GoDart_CloseNativePort(C.int64_t(port))

	return (bool)(result)
}

func GetStringList(stringListPtrAddr int64) []string {
	stringList := C.GetStringList(C.int64_t(stringListPtrAddr))

	length := stringList.size
	tmpSlice := (*[1 << 30]*C.char)(unsafe.Pointer(stringList.list))[:length:length]

	goSlice := make([]string, length)
	for i, s := range tmpSlice {
		goSlice[i] = C.GoString(s)
	}

	return goSlice
}

// List the archive
func SendArchiveListing(port int64, err error, result *[]onearchiver.ArchiveFileInfo) {
	var dartObj C.Dart_CObject
	dartObj._type = C.Dart_CObject_kInt64

	// Parse errors
	var ei C.struct_ErrorInfo
	if err != nil {
		ei.error = C.CString(err.Error())
		ei.errorType = C.CString(processErrors(err))
	}

	var aiList []*C.struct_ArcFileInfo

	for _, item := range *result {
		aif := (*C.struct_ArcFileInfo)(C.malloc(C.sizeof_struct_ArcFileInfo))

		mode, err := strconv.ParseInt(fmt.Sprintf("%o", item.Mode.Perm()), 10, 64)
		if err != nil {
			aif.mode = C.uint32_t(0)
		} else {
			aif.mode = C.uint32_t(mode)
		}

		aif.size = C.int64_t(item.Size)
		aif.name = C.CString(item.Name)
		aif.isDir = C.bool(item.IsDir)
		aif.modTime = C.CString(item.ModTime.String())
		aif.fullPath = C.CString(item.FullPath)

		aiList = append(aiList, aif)
	}

	aiListLen := len(aiList)

	air := (*C.struct_ArcFileInfoResult)(C.malloc(C.sizeof_struct_ArcFileInfoResult))

	if aiListLen > 0 {
		air.files = &aiList[0]
	} else {
		air.files = nil
	}

	air.totalFiles = C.int64_t(aiListLen)
	air.error = &ei

	ptrAddr := C.GetArcFileInfoResultPtr(air)

	*(*C.int64_t)(unsafe.Pointer(&dartObj.value[0])) = C.int64_t(ptrAddr)
	C.GoDart_PostCObject(C.int64_t(port), &dartObj)
}

func FreeListArchiveMemory(ptrAddr int64) {
	C.ClearListArchiveMemory(C.int64_t(ptrAddr))
}

// Check if the archive is encrypted
func SendIsArchiveEncrypted(port int64, err error, result *onearchiver.EncryptedArchiveInfo) {
	var dartObj C.Dart_CObject
	dartObj._type = C.Dart_CObject_kInt64

	// Parse errors
	var ei C.struct_ErrorInfo
	if err != nil {
		ei.error = C.CString(err.Error())
		ei.errorType = C.CString(processErrors(err))
	}

	eai := (*C.struct_EncryptedArchiveInfo)(C.malloc(C.sizeof_struct_EncryptedArchiveInfo))

	eai.isEncrypted = C.bool(result.IsEncrypted)
	eai.isValidPassword = C.bool(result.IsValidPassword)
	eai.error = &ei

	ptrAddr := C.GetEncryptedArchiveResultPtr(eai)

	*(*C.int64_t)(unsafe.Pointer(&dartObj.value[0])) = C.int64_t(ptrAddr)
	C.GoDart_PostCObject(C.int64_t(port), &dartObj)
}

func FreeIsArchiveEncryptedMemory(ptrAddr int64) {
	C.ClearIsArchiveEncryptedMemory(C.int64_t(ptrAddr))
}
