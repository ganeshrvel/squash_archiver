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

	StringList GetStringList(int64_t stringListPtrAddr) {
        StringList *p = (struct StringList *) stringListPtrAddr;

		return *p;
	}

	// Listing
	typedef struct ArcFileInfo{
		uint32_t mode;
		uint64_t size;
		bool	isDir;
		char 	*modTime;
		char 	*name;
		char 	*fullPath;
	}ArcFileInfo;

	typedef struct ArcFileInfoResult{
		ArcFileInfo **files;
		uint64_t totalFiles;
		ErrorInfo *error;
	}ArcFileInfoResult;

	int64_t GetArcFileInfoResultAddr(struct ArcFileInfoResult *pResult) {
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
	typedef struct EncryptedArchiveInfoResult{
		bool isEncrypted;
		bool isValidPassword;
		ErrorInfo *error;
	}EncryptedArchiveInfoResult;

	int64_t GetEncryptedArchiveResultAddr(struct EncryptedArchiveInfoResult *pResult) {
		int64_t ptr = (int64_t)pResult;

		return ptr;
	}

	void ClearIsArchiveEncryptedMemory(int64_t ptrAddr) {
		EncryptedArchiveInfoResult *pResult = (struct EncryptedArchiveInfoResult *) ptrAddr;

		free(&pResult->isEncrypted);
		free(&pResult);
	}

	// Pack files
	typedef struct PackFilesResult{
		char *startTime;
		char *currentFilename;
		uint64_t totalFiles;
		uint64_t progressCount;
		double progressPercentage;
		bool ended;
		ErrorInfo *error;
	}PackFilesResult;

	int64_t GetPackFilesResultAddr(struct PackFilesResult *pResult) {
		int64_t ptr = (int64_t)pResult;

		return ptr;
	}

	void ClearPackFilesMemory(int64_t ptrAddr) {
		PackFilesResult *pResult = (struct PackFilesResult *) ptrAddr;

		free(&pResult->startTime);
		free(&pResult);
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

		aif.size = C.uint64_t(item.Size)
		aif.name = C.CString(item.Name)
		aif.isDir = C.bool(item.IsDir)
		aif.modTime = C.CString(item.ModTime.Format(DateTimeFormat))
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

	air.totalFiles = C.uint64_t(aiListLen)
	air.error = &ei

	ptrAddr := C.GetArcFileInfoResultAddr(air)

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

	eai := (*C.struct_EncryptedArchiveInfoResult)(C.malloc(C.sizeof_struct_EncryptedArchiveInfoResult))

	eai.isEncrypted = C.bool(result.IsEncrypted)
	eai.isValidPassword = C.bool(result.IsValidPassword)
	eai.error = &ei

	ptrAddr := C.GetEncryptedArchiveResultAddr(eai)
	*(*C.int64_t)(unsafe.Pointer(&dartObj.value[0])) = C.int64_t(ptrAddr)
	C.GoDart_PostCObject(C.int64_t(port), &dartObj)
}

func FreeIsArchiveEncryptedMemory(ptrAddr int64) {
	C.ClearIsArchiveEncryptedMemory(C.int64_t(ptrAddr))
}

// Pack files
func SendPackFiles(port int64, err error, pInfo *onearchiver.ProgressInfo, packingEnded bool) {
	var dartObj C.Dart_CObject
	dartObj._type = C.Dart_CObject_kInt64

	// Parse errors
	var ei C.struct_ErrorInfo
	if err != nil {
		ei.error = C.CString(err.Error())
		ei.errorType = C.CString(processErrors(err))
	}

	pf := (*C.struct_PackFilesResult)(C.malloc(C.sizeof_struct_PackFilesResult))
	pf.startTime = C.CString(pInfo.StartTime.Format(DateTimeFormat))
	pf.currentFilename = C.CString(pInfo.CurrentFilename)
	pf.progressCount = C.uint64_t(pInfo.ProgressCount)
	pf.totalFiles = C.uint64_t(pInfo.TotalFiles)
	pf.progressPercentage = C.double(pInfo.ProgressPercentage)
	pf.ended = C.bool(packingEnded)
	pf.error = &ei

	ptrAddr := C.GetPackFilesResultAddr(pf)

	*(*C.int64_t)(unsafe.Pointer(&dartObj.value[0])) = C.int64_t(ptrAddr)
	C.GoDart_PostCObject(C.int64_t(port), &dartObj)
}

func FreePackFilesMemory(ptrAddr int64) {
	C.ClearPackFilesMemory(C.int64_t(ptrAddr))
}
