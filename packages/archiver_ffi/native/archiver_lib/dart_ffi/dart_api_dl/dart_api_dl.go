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
		//IsDir    bool
		//ModTime  time.Time
		char *Name;
		char *FullPath;
	}ArcFileInfo;



	//typedef struct ArcTest{
	//	char **files;
	//}ArcTest;
	//
	//int64_t GetChar(void **goResult, char **files) {
	//	ArcTest *result = (ArcTest *)malloc(sizeof(ArcTest));
	//	result->files=files;
	//
	//	*goResult = result;
	//
	//	int64_t ptr = (int64_t)result;
	//
	//	return 0;
	//}

	typedef struct ArcFileInfoResult{
		ArcFileInfo **files;
	}ArcFileInfoResult;


	int64_t GetArcFileInfoResultPtr(ArcFileInfoResult *result) {
		int64_t ptr = (int64_t)result;

		return ptr;
	}

	int64_t GetArcFileInfoResult(void **goResult, ArcFileInfo **files) {
		ArcFileInfoResult *result = (ArcFileInfoResult *)malloc(sizeof(ArcFileInfoResult));
		result->files=files;

		*goResult = result;

		int64_t ptr = (int64_t)result;

		return ptr;
	}

	int64_t GetArcFileInfo(ArcFileInfo **files) {
		int64_t ptr = (int64_t)files;

		return ptr;
	}

	typedef struct WorkStruct{
		char *name;
		int64_t age;
		char ** string_list;
	}WorkStruct;

	int64_t GetWork(void **ppWork, char* name, int64_t age, char** string_list) {
		WorkStruct *pWork = (WorkStruct *)malloc(sizeof(WorkStruct));
		pWork->name=name;
		pWork->age=age;
		pWork->string_list = string_list;

		*ppWork = pWork;

		int64_t ptr = (int64_t)pWork;

		return ptr;
	}

	void clearWorkStructMemory(WorkStruct pWork) {
		free(&pWork.name);
		free(&pWork.age);
		free(&pWork.string_list);
		free(&pWork);
	}



	typedef struct FileInfo{
		int64_t Size;
		char *Name;
	}FileInfo;

	typedef struct Result{
		FileInfo **files;
	}Result;

	int64_t GetResult(void **presult, FileInfo *files) {
		Result *result = (Result *)malloc(sizeof(Result));
		result->files[0]=files;

		*presult = result;

		int64_t ptr = (int64_t)result;

		return ptr;
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

//type ArcFileInfo struct {
//	Mode C.int32_t
//	Size C.int64_t
//	//IsDir    bool
//	//ModTime  time.Time
//	Name     *C.char
//	FullPath *C.char
//}


func SendArchiveListing(port int64, err error, result *[]onearchiver.ArchiveFileInfo) {
	//var arr []*C.struct_ArcFileInfo
	//
	//ai := C.struct_ArcFileInfo{
	//	Mode:     C.int32_t(112),
	//	Size:     C.int64_t(12323),
	//	Name:     C.CString("item.Name"),
	//	FullPath: C.CString("item.FullPath"),
	//}
	//
	//

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
	aif.FullPath = C.CString("item.FullPath")

	aiList = append(aiList, aif)

	air := &C.struct_ArcFileInfoResult{}
	air = (*C.struct_ArcFileInfoResult)(C.malloc(C.size_t(unsafe.Sizeof(C.struct_ArcFileInfoResult{}))))

	air.files = &aiList[0]

	//var pwork unsafe.Pointer
	ptrAddr := C.GetArcFileInfoResultPtr(air)

	//aiPtr := C.GetArcFileInfo(&arr[0])

	//defer C.free(unsafe.Pointer(student.student.name))
	//proper cleanup
	//the first &StudentHeader{} doesn't need to be cleaned up
	//because go is Awesome!
	//mallocd data must be freed
	//C.CString must be freed
	//C.free(unsafe.Pointer(student))

	//var arr []*C.struct_FileInfo
	/*
		ai := FileInfo{
			Size: C.int64_t(1234),
			Name: C.CString("some name"),
		}

		//arr = append(arr, &ai)

		var presult unsafe.Pointer
		ptr := C.GetResult(&presult, &ai)

		println("\nResult struct pointer: %v", ptr)*/

	//var aiList []*C.struct_ArcFileInfo

	////cAi := *((*C.struct_ArcFileInfo)(unsafe.Pointer(ai)))
	//for _, item := range *result {
	//	ai := ArcFileInfo{
	//		Mode:     C.int32_t(item.Mode),
	//		Size:     C.int64_t(item.Size),
	//		Name:     C.CString(item.Name),
	//		FullPath: C.CString(item.FullPath),
	//	}
	//
	//	pr := *((*C.struct_ArcFileInfo)(&ai))
	//
	//	aiList = append(aiList, &pr)
	//}
	//
	//
	//var pwork unsafe.Pointer
	//ptrAddr := C.GetArcFileInfo(&pwork, &aiList[0])
	//
	//pretty.Println(ptrAddr)

	//=============
	//	var aiList []*C.struct_ArcFileInfo

	//for _, item := range *result {
	//	ai := ArcFileInfo{
	//		Mode:     C.int32_t(item.Mode),
	//		Size:     C.int64_t(item.Size),
	//		Name:     C.CString(item.Name),
	//		FullPath: C.CString(item.FullPath),
	//	}
	//
	//	pr := *((*C.struct_ArcFileInfo)(&ai))
	//
	//	aiList = append(aiList, &pr)
	//}
	//sz := 2
	//_ = (*C.struct_ArcFileInfo)(C.malloc(C.size_t(len(*result))))
	//ps := (*[]C.struct_ArcFileInfo)(unsafe.Pointer(aiList))[]

	//var arr []*C.struct_ArcFileInfo
	//
	//ai := C.struct_ArcFileInfo{
	//	Mode:     C.int32_t(112),
	//	Size:     C.int64_t(12323),
	//	Name:     C.CString("item.Name"),
	//	FullPath: C.CString("item.FullPath"),
	//}
	//
	//arr = append(arr, &ai)
	//
	//aiPtr := C.GetArcFileInfo(&arr[0])
	//
	//var pwork unsafe.Pointer
	//ptrAddr := C.GetArcFileInfoResult(&pwork, aiPtr)

	//ps := *(*C.struct_ArcFileInfo)(unsafe.Pointer(&ai))
	//
	//arr = append(arr, &ps)
	//
	//infoResult := C.struct_ArcFileInfoResult{
	//	files: &arr[0],
	//}
	//
	//psr := (*C.struct_ArcFileInfoResult)(unsafe.Pointer(&infoResult))

	///////////////

	//var infoResult C.ArcFileInfoResult

	//*(*C.struct_ArcFileInfo)(unsafe.Pointer(&infoResult.files)) = *arr[0]

	//===========

	//var pwork unsafe.Pointer
	//ptr := C.GetArcFileInfo(psr)
	//===============

	//cAiList := []C.struct_ArcFileInfo{cAi}

	//t := []*C.char{C.CString("Item 1"), C.CString("Item 2"), C.CString("Item 3")}
	//
	//r := ArcFileInfoResult{
	//	//result: &cAiList,
	//	result: &t[0],
	//}
	//
	//pr := *((*C.struct_ArcFileInfoResult)(unsafe.Pointer(&r)))

	//p1 := (C.pInt)(unsafe.Pointer(&pr))

	//
	//_ptr := *((*C.struct_Test)(unsafe.Pointer(
	//	&Test{
	//		abc: C.int64_t(12345), xyz: C.CString("abcdef"),
	//	})))
	//

	//_ = C.GetArcFileInfo(&pr)

	//___ptr := *((*C.int64_t)(unsafe.Pointer(&_ptr)))
	//
	//
	//itemArr := []*C.char{C.CString("Item 1"), C.CString("Item 2"), C.CString("Item 3")}
	//
	//var pwork unsafe.Pointer
	//ptrAddr := C.GetWork(&pwork, C.CString("Smith"), C.int64_t(msg), &itemArr[0])
	//
	//
	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = ptrAddr

	C.GoDart_PostCObject(C.int64_t(port), &obj)
}

func FreeWorkStructMemory(pointer *int64) {
	ptr := (*C.struct_WorkStruct)(unsafe.Pointer(pointer))
	C.clearWorkStructMemory(*ptr)
}
