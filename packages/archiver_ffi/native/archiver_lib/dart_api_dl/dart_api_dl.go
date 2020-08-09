package dart_api_dl

// #include "stdint.h"
// #include "include/dart_api_dl.c"
//
// // Go does not allow calling C function pointers directly. So we are
// // forced to provide a trampoline.
// bool GoDart_PostCObject(Dart_Port_DL port, Dart_CObject* obj) {
//   return Dart_PostCObject_DL(port, obj);
// }
//
//	typedef struct example_struct {
//		int64_t a;
//		int64_t b;
//	}exampleStruct;
import "C"
import (
	"unsafe"
)

func Init(api unsafe.Pointer) C.long {
	return C.Dart_InitializeApiDL(api)
}

type exampleStruct struct {
	a int64
	b int64
}

func SendToPortArray(port int64, msg int64) {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kArray

	strValue := []string{"Ganesh"} // dummy values

	unsafePtr := *(*[]string)(unsafe.Pointer(&strValue))

	*(*[]string)(unsafe.Pointer(&obj.value[0])) = unsafePtr

	C.GoDart_PostCObject(C.int64_t(port), &obj)
}

func SendToPortInt(port int64, msg int64) {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64

	//// cgo does not support unions so we are forced to do this
	unsafePtr := *(*C.int64_t)(unsafe.Pointer(&msg))
	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = unsafePtr

	C.GoDart_PostCObject(C.int64_t(port), &obj)
}

func SendToPort(port int64, msg int64) {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kArray

	structValue := exampleStruct{a: int64(1), b: int64(2)} // dummy values

	unsafePtr := *(*C.struct_example_struct)(unsafe.Pointer(&structValue))

	*(*C.struct_example_struct)(unsafe.Pointer(&obj.value[0])) = unsafePtr

	C.GoDart_PostCObject(C.int64_t(port), &obj)
}
