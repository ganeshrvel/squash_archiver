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
//	int64_t GetWork(void **ppWork, char* name, int64_t age, char* string_list) {
//		WorkStruct *pWork= (WorkStruct *)malloc(sizeof(WorkStruct));
//		pWork->name=name;
//		pWork->age=age;
//		pWork->string_list= malloc( 2* sizeof(char*));
//		pWork->string_list[0] = malloc( 5 * sizeof(char));
//		pWork->string_list[0] = "item 3";
//		pWork->string_list[1] = malloc( 5 * sizeof(char));
//		pWork->string_list[1] = "item 4";
//		pWork->string_list[2] = NULL;
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

	arr := []string{"Item1\u0000", "item2\u0000", "item3\u0000"}
	ptr := unsafe.Pointer(&arr)

	var pwork unsafe.Pointer
	ptrAddr := C.GetWork(&pwork, C.CString("Smith"), C.int64_t(26), (*C.char)(ptr))

	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = ptrAddr

	/*	work := *(*WorkStruct)(pwork)

		println(work.string_list)*/

	/*	c := []string{"may", "god"}
		cc := (*[]C.CString)(unsafe.Pointer(&c))*/

	//fmt.Println(cc)

	//cfa := (*[6]float64)(unsafe.Pointer(&c))
	//cfs := cfa[:]

	C.GoDart_PostCObject(C.int64_t(port), &obj)

	//defer C.free(pwork)
}
