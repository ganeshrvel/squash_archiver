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
	}ArcFileInfoResult;

	int64_t GetArcFileInfoResultPtr(ArcFileInfoResult *pResult) {
		int64_t ptr = (int64_t)pResult;

		return ptr;
	}

	void ClearArcFileInfoResultMemory(int64_t ptrAddr) {
		ArcFileInfoResult *pResult = (struct ArcFileInfoResult *) ptrAddr;

		for (int i = 0; i < pResult->totalFiles; i++) {
			free(&pResult->files[i]->mode);
		}

		free(&pResult->files);
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

type ErrorInfo struct {
	errorType, error string
}

func SendArchiveListing(port int64, err error, result *[]onearchiver.ArchiveFileInfo) {
	var ei ErrorInfo

	// Parse errors
	ei.processErrors(err)

	var dartObj C.Dart_CObject
	dartObj._type = C.Dart_CObject_kInt64

	var aiList []*C.struct_ArcFileInfo

	for _, item := range *result {
		aif := (*C.struct_ArcFileInfo)(C.malloc(C.sizeof_struct_ArcFileInfo))

		mode, _ := strconv.ParseInt(fmt.Sprintf("%o", item.Mode.Perm()), 10, 64)
		aif.mode = C.uint32_t(mode)
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

	ptrAddr := C.GetArcFileInfoResultPtr(air)

	*(*C.int64_t)(unsafe.Pointer(&dartObj.value[0])) = C.int64_t(ptrAddr)
	C.GoDart_PostCObject(C.int64_t(port), &dartObj)

	//go func() {
	//	//defer C.free(unsafe.Pointer(&ptr.Mode))
	//	//defer C.free(unsafe.Pointer(&ptr.Size))
	//	//defer C.free(unsafe.Pointer(ptr.Name))
	//	//defer C.free(unsafe.Pointer(&ptr.IsDir))
	//	//defer C.free(unsafe.Pointer(&ptr.ModTime))
	//	//defer C.free(unsafe.Pointer(&ptr.FullPath))
	//	//defer C.free(unsafe.Pointer(&ptr))
	//	//defer C.free(unsafe.Pointer(&air.files))
	//	//defer C.free(unsafe.Pointer(&air))
	//
	//	for i := 0; i < 3; i++ {
	//		time.Sleep(7000 * time.Millisecond)
	//		//pretty.Println("\ninside go routine ptrAddr", ptrAddr)
	//
	//		//ptr := *(*C.struct_ArcFileInfo)(unsafe.Pointer(C.int64_t(&ptrAddr)))
	//		//p1 := *(*C.int64_t)(&ptrAddr)
	//		//ptr := *(*C.struct_ArcFileInfoResult)(unsafe.Pointer(C.int64_t(&ptrAddr)))
	//		//ptr := (*C.struct_ArcFileInfoResult)(unsafe.Pointer(*(*C.int64_t)(&ptrAddr)))
	//
	//		//air := (*C.struct_ArcFileInfoResult)(unsafe.Pointer(*(*C.int64_t)(&ptrAddr)))
	//		//files := (*[1 << 30]*C.struct_ArcFileInfo)(unsafe.Pointer(*air.files))[:1]
	//
	//		//pretty.Println("\n", aif)
	//	}
	//}()
}

func FreeListArchiveMemory(ptrAddr int64) {
	C.ClearArcFileInfoResultMemory(C.int64_t(ptrAddr))
}
