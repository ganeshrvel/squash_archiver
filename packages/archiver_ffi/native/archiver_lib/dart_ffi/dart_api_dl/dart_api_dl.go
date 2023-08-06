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
	bool GoDart_PostCObject(Dart_Port_DL port, int64_t ptrAddr) {
  		Dart_CObject dartObj;
  		dartObj.type = Dart_CObject_kInt64;

		dartObj.value.as_int64 = ptrAddr;

	    return Dart_PostCObject_DL(port, &dartObj);
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
		char 	*parentPath;
		char 	*extension;
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

		if (pResult == NULL) {
			return;
		}

		if (pResult->error != NULL) {
			free(pResult->error->error);
			free(pResult->error->errorType);
			free(pResult->error);
		}

		if (pResult->files != NULL) {
			for (uint64_t i = 0; i < pResult->totalFiles; i++) {
				if (pResult->files[i] != NULL) {
					free(pResult->files[i]->modTime);
					free(pResult->files[i]->name);
					free(pResult->files[i]->fullPath);
					free(pResult->files[i]->parentPath);
					free(pResult->files[i]->extension);
					free(pResult->files[i]);
				}
			}
		}

		free(pResult);
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

		if (pResult == NULL) {
			return;
		}

		if (pResult->error != NULL) {
			free(pResult->error->error);
			free(pResult->error->errorType);
			free (pResult->error);
		}

		free(pResult);
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

		if (pResult == NULL) {
			return;
		}

		if (pResult->error != NULL) {
			free(pResult->error->error);
			free(pResult->error->errorType);
			free(pResult->error);
		}

		free(pResult->startTime);
		free(pResult);
	}

	// Unpack files
	typedef struct UnpackFilesResult{
		char *startTime;
		char *currentFilename;
		uint64_t totalFiles;
		uint64_t progressCount;
		double progressPercentage;
		bool ended;
		ErrorInfo *error;
	}UnpackFilesResult;

	int64_t GetUnpackFilesResultAddr(struct UnpackFilesResult *pResult) {
		int64_t ptr = (int64_t)pResult;

		return ptr;
	}

	void ClearUnpackFilesMemory(int64_t ptrAddr) {
		UnpackFilesResult *pResult = (struct UnpackFilesResult *) ptrAddr;

		if (pResult == NULL) {
			return;
		}

		if (pResult->error != NULL) {
			free(pResult->error->error);
			free(pResult->error->errorType);
			free(pResult->error);
		}

		free(pResult->startTime);
		free(pResult);
	}
*/
import "C"

func InitializeDartApi(api unsafe.Pointer) {
	if C.Dart_InitializeApiDL(api) != 0 {
		panic("failed to initialize Dart DL C API: version mismatch. " +
			"must update include/ to match Dart SDK version")
	}
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

// SendArchiveListing - List the archive
func SendArchiveListing(port int64, err error, result *[]onearchiver.ArchiveFileInfo) {
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
		aif.parentPath = C.CString(item.ParentPath)
		aif.extension = C.CString(item.Extension)

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

	if err != nil {
		ei := (*C.struct_ErrorInfo)(C.malloc(C.sizeof_struct_ErrorInfo))

		ei.error = C.CString(err.Error())
		ei.errorType = C.CString(processErrors(err, TaskListArchive))
		air.error = ei
	}

	ptrAddr := C.GetArcFileInfoResultAddr(air)

	C.GoDart_PostCObject(C.int64_t(port), C.int64_t(ptrAddr))
}

func FreeListArchiveMemory(ptrAddr int64) {
	C.ClearListArchiveMemory(C.int64_t(ptrAddr))
}

// SendIsArchiveEncrypted - Check if the archive is encrypted
func SendIsArchiveEncrypted(port int64, err error, result *onearchiver.EncryptedArchiveInfo) {
	// Parse errors
	eai := (*C.struct_EncryptedArchiveInfoResult)(C.malloc(C.sizeof_struct_EncryptedArchiveInfoResult))

	eai.isEncrypted = C.bool(result.IsEncrypted)
	eai.isValidPassword = C.bool(result.IsValidPassword)

	if err != nil {
		ei := (*C.struct_ErrorInfo)(C.malloc(C.sizeof_struct_ErrorInfo))

		ei.error = C.CString(err.Error())
		ei.errorType = C.CString(processErrors(err, TaskIsArchiveEncrypted))
		eai.error = ei
	}

	ptrAddr := C.GetEncryptedArchiveResultAddr(eai)

	C.GoDart_PostCObject(C.int64_t(port), C.int64_t(ptrAddr))
}

func FreeIsArchiveEncryptedMemory(ptrAddr int64) {
	C.ClearIsArchiveEncryptedMemory(C.int64_t(ptrAddr))
}

// SendPackFiles - Pack files
func SendPackFiles(port int64, err error, pInfo *onearchiver.ProgressInfo, packingEnded bool) {
	pf := (*C.struct_PackFilesResult)(C.malloc(C.sizeof_struct_PackFilesResult))
	pf.startTime = C.CString(pInfo.StartTime.Format(DateTimeFormat))
	pf.currentFilename = C.CString(pInfo.CurrentFilename)
	pf.progressCount = C.uint64_t(pInfo.ProgressCount)
	pf.totalFiles = C.uint64_t(pInfo.TotalFiles)
	pf.progressPercentage = C.double(pInfo.ProgressPercentage)
	pf.ended = C.bool(packingEnded)

	if err != nil {
		ei := (*C.struct_ErrorInfo)(C.malloc(C.sizeof_struct_ErrorInfo))

		ei.error = C.CString(err.Error())
		ei.errorType = C.CString(processErrors(err, TaskPackFiles))
		pf.error = ei
	}

	ptrAddr := C.GetPackFilesResultAddr(pf)

	C.GoDart_PostCObject(C.int64_t(port), C.int64_t(ptrAddr))
}

func FreePackFilesMemory(ptrAddr int64) {
	C.ClearPackFilesMemory(C.int64_t(ptrAddr))
}

// SendUnpackFiles - Unpack files
func SendUnpackFiles(port int64, err error, pInfo *onearchiver.ProgressInfo, packingEnded bool) {
	pf := (*C.struct_UnpackFilesResult)(C.malloc(C.sizeof_struct_UnpackFilesResult))
	pf.startTime = C.CString(pInfo.StartTime.Format(DateTimeFormat))
	pf.currentFilename = C.CString(pInfo.CurrentFilename)
	pf.progressCount = C.uint64_t(pInfo.ProgressCount)
	pf.totalFiles = C.uint64_t(pInfo.TotalFiles)
	pf.progressPercentage = C.double(pInfo.ProgressPercentage)
	pf.ended = C.bool(packingEnded)

	if err != nil {
		ei := (*C.struct_ErrorInfo)(C.malloc(C.sizeof_struct_ErrorInfo))

		ei.error = C.CString(err.Error())
		ei.errorType = C.CString(processErrors(err, TaskUnpackFiles))
		pf.error = ei
	}

	ptrAddr := C.GetUnpackFilesResultAddr(pf)

	C.GoDart_PostCObject(C.int64_t(port), C.int64_t(ptrAddr))
}

func FreeUnpackFilesMemory(ptrAddr int64) {
	C.ClearUnpackFilesMemory(C.int64_t(ptrAddr))
}
