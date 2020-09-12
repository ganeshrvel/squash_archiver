package dart_api_dl

import "C"
import (
	onearchiver "github.com/ganeshrvel/one-archiver"
	"github.com/kr/pretty"
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
		int32_t mode;
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

		//printf("\ninitial ptrAddr: %d", ptr);

		return ptr;
	}

	void ClearArcFileInfoResultMemory(int64_t ptrAddr) {
   		//printf("%d : recieved pointer\n", ptrAddr);

		ArcFileInfoResult *pResult = (struct ArcFileInfoResult *) ptrAddr;

	//	printf("%d casting back\n", pResult);

		//printf("%d totalFiles\n", pResult->totalFiles);

		//free(&pResult->files);

		for (int i = 0; i < pResult->totalFiles; i++) {
			//ArcFileInfo file = *pResult.files[i];

			free(&pResult->files[i]->mode);
			//free(&pResult->files[i]->size);
		//	free(&pResult->files[i]->isDir);
			//free(&pResult->files[i]->modTime);
			//free(&pResult->files[i]->name);
			//free(&pResult->files[i]->fullPath);
			//free(&pResult->files[i]);
			//printf("%d after freeing \n", pResult->files[i]->size);
		}

		free(&pResult->files);
		free(&pResult);

		//sleep(1);

		//printf("%d clearing totalFiles\n", pResult->files);
		//
		//for (int i = 0; i < pResult->totalFiles; i++) {
		//	//ArcFileInfo file = *pResult.files[i];
		//
		//	//free(&pResult->files[i]->mode);
		//	printf("%d after freeing files \n", pResult->files[i]->size);
		//}

		//free(&pWork.name);
		//free(&pWork.age);
		//free(&pWork.string_list);
		//free(&pWork);
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

	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64

	var aiList []*C.struct_ArcFileInfo
	aif := (*C.struct_ArcFileInfo)(C.malloc(C.sizeof_struct_ArcFileInfo))

	aif.mode = C.int32_t(12346)
	aif.size = C.int64_t(987654)
	aif.name = C.CString("Name")
	aif.isDir = true
	aif.modTime = C.CString("ModTime")
	aif.fullPath = C.CString("FullPath")
	aiList = append(aiList, aif)

	air := (*C.struct_ArcFileInfoResult)(C.malloc(C.sizeof_struct_ArcFileInfoResult))
	air.files = &aiList[0]
	air.totalFiles = C.int64_t(len(aiList))

	ptrAddr := C.GetArcFileInfoResultPtr(air)

	pretty.Println("\ncasted go ptrAddr", ptrAddr)

	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = C.int64_t(ptrAddr)
	C.GoDart_PostCObject(C.int64_t(port), &obj)

	//go func() {
	//	time.Sleep(1000 * time.Millisecond)
	//	//ptr := *(*C.struct_ArcFileInfo)(unsafe.Pointer(C.int64_t(&ptrAddr)))
	//	p1 := (*C.int64_t)(&ptrAddr)
	//	ptr := (*C.struct_ArcFileInfoResult)(unsafe.Pointer(p1))
	//
	//	pretty.Println("\n", *ptr.files[0].Mode)
	//
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
	//	for i := 0; i < 1000; i++ {
	//		time.Sleep(1000 * time.Millisecond)
	//		fmt.Println("world")
	//	}
	//}()
}

func FreeListArchiveMemory(ptrAddr int64) {
	pretty.Println("\nreturned ptrAddr", ptrAddr)

	//ptr := *(*C.struct_ArcFileInfoResult)(unsafe.Pointer(pointer))
	C.ClearArcFileInfoResultMemory(C.int64_t(ptrAddr))

	//air := *(*C.struct_ArcFileInfoResult)(unsafe.Pointer(pointer))
	//////C.clearWorkStructMemory(*ptr)
	////
	//files := (*[1 << 30]*C.struct_ArcFileInfo)(unsafe.Pointer(*air.files))[:1]
	////
	////
	//for _, item := range files {
	//	_item := *(*C.struct_ArcFileInfo)(unsafe.Pointer(&item))
	//
	//	pretty.Println(_item.mode)
	//	//C.free(unsafe.Pointer(*_item.mode))
	//	//pretty.Println(item.mode)
	//	//pretty.Println(unsafe.Pointer(&item.mode))
	//
	//	//C.free(unsafe.Pointer(item))
	//	//C.free(unsafe.Pointer(item.name))
	//	//C.free(unsafe.Pointer(&item.isDir))
	//	//C.free(unsafe.Pointer(item.modTime))
	//	//C.free(unsafe.Pointer(item.fullPath))
	//	//C.free(unsafe.Pointer(&item))
	//}

	//teamSlice := (*[1 << 30]C.struct_ArcFileInfo)(files)[:1]
	//
	//pretty.Println(files)
	//pretty.Println(*files.Mode)

	/// todo free all pointers
	//defer C.free(unsafe.Pointer(&aif.Mode))
	//defer C.free(unsafe.Pointer(&aif.Size))
	//defer C.free(unsafe.Pointer(&aif.Name))
	//defer C.free(unsafe.Pointer(&aif.IsDir))
	//defer C.free(unsafe.Pointer(&aif.ModTime))
	//defer C.free(unsafe.Pointer(&aif.FullPath))
	//defer C.free(unsafe.Pointer(&aif))
	//
	//todo
	//defer C.free(unsafe.Pointer(&air.files))
	//defer C.free(unsafe.Pointer(&air))
}
