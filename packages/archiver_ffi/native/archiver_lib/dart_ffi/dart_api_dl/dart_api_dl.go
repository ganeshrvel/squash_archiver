package dart_api_dl

import "C"
import (
	onearchiver "github.com/ganeshrvel/one-archiver"
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

	typedef struct ArcFileInfo{
		int32_t Mode;
		int64_t Size;
		bool	IsDir;
		char 	*ModTime;
		char 	*Name;
		char 	*FullPath;
	}ArcFileInfo;

	typedef struct ArcFileInfoResult{
		ArcFileInfo **files;
	}ArcFileInfoResult;
*/
import "C"

func InitializeDartApi(api unsafe.Pointer) C.long {
	return C.Dart_InitializeApiDL(api)
}

func CloseNativePort(port int64) bool {
	result := C.GoDart_CloseNativePort(C.int64_t(port))

	return (bool)(result)
}

type ErrorInfo struct {
	errorType, error string
}

func SendArchiveListing(port int64, err error, result *[]onearchiver.ArchiveFileInfo) {
	var ei ErrorInfo

	// Parse errors
	ei.processErrors(err)

	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64

	var aiList []*C.struct_ArcFileInfo

	aif := &C.struct_ArcFileInfo{}
	aif = (*C.struct_ArcFileInfo)(C.malloc(C.size_t(unsafe.Sizeof(C.struct_ArcFileInfo{}))))

	aif.Mode = C.int32_t(112)
	aif.Size = C.int64_t(12323)
	aif.Name = C.CString("item.Name")
	aif.IsDir = true
	aif.ModTime = C.CString("item.ModTime")
	aif.FullPath = C.CString("item.FullPath")
	aiList = append(aiList, aif)

	air := &C.struct_ArcFileInfoResult{}
	air = (*C.struct_ArcFileInfoResult)(C.malloc(C.size_t(unsafe.Sizeof(C.struct_ArcFileInfoResult{}))))
	air.files = &aiList[0]

	ptrAddr := *((*C.int64_t)(unsafe.Pointer(&air)))

	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = ptrAddr
	C.GoDart_PostCObject(C.int64_t(port), &obj)
}

//func FreeWorkStructMemory(pointer *int64) {
//	ptr := (*C.struct_WorkStruct)(unsafe.Pointer(pointer))
//	C.clearWorkStructMemory(*ptr)
/// todo free all pointers
//defer C.free(unsafe.Pointer(&aif.Mode))
//defer C.free(unsafe.Pointer(&aif.Size))
//defer C.free(unsafe.Pointer(&aif.Name))
//defer C.free(unsafe.Pointer(&aif.IsDir))
//defer C.free(unsafe.Pointer(&aif.ModTime))
//defer C.free(unsafe.Pointer(&aif.FullPath))
//defer C.free(unsafe.Pointer(&aif))

// todo
//defer C.free(unsafe.Pointer(&air.files))
//defer C.free(unsafe.Pointer(&air))
//}
