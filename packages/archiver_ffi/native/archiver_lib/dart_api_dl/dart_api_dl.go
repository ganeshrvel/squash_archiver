package dart_api_dl

import "C"
import (
	"unsafe"
)

// #include "stdlib.h"
// #include "stdint.h"
// #include "include/dart_api_dl.c"
//
// // Go does not allow calling C function pointers directly. So we are
// // forced to provide a trampoline.
// bool GoDart_PostCObject(Dart_Port_DL port, Dart_CObject* obj) {
//   return Dart_PostCObject_DL(port, obj);
// }
//
//	//export WorkStruct
//	typedef struct WorkStruct{
//		char *name;
//		int64_t age;
//		char ** string_list;
//	}WorkStruct;
//
//	int64_t GetWork(void **ppWork, char* name, int64_t age, char** string_list) {
//		WorkStruct *pWork= (WorkStruct *)malloc(sizeof(WorkStruct));
//		pWork->name=name;
//		pWork->age=age;
//		pWork->string_list = string_list;
//
//		*ppWork = pWork;
//
//		int64_t ptr = (int64_t)pWork;
//
//		return ptr;
//	}
import "C"

func Init(api unsafe.Pointer) C.long {
	return C.Dart_InitializeApiDL(api)
}

/*type WorkStruct struct {
	name        int64
	age         int64
	string_list []string
}*/

func SendToPort(port int64, msg int64) {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64

	/*arr := []string{"Item1\u0000", "item2\u0000", "item3\u0000", "\u0000"}
	ptr := unsafe.Pointer(&arr)*/

	itemArr := []*C.char{C.CString("Item1"), C.CString("Item2"), C.CString("Item3")}
	//ptr := unsafe.Pointer(&arr)
	//ptr := unsafe.Pointer(&arr[0])

	//	*(*C.char)(unsafe.Pointer(&arr));

	var pwork unsafe.Pointer
	ptrAddr := C.GetWork(&pwork, C.CString("Smith"), C.int64_t(26), &itemArr[0])

	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = ptrAddr

	C.GoDart_PostCObject(C.int64_t(port), &obj)

}
