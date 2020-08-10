package dart_api_dl

import "C"
import "unsafe"

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
//	typedef struct Work{
//		int64_t a;
//		int64_t b;
//	}Work;
//
//	void GetWork(void **ppWork) {
//		Work *pWork= (Work *)malloc(sizeof(Work));
//		pWork->a=5;
//		pWork->b=6;
//		*ppWork = pWork;
//	}
import "C"

func Init(api unsafe.Pointer) C.long {
	return C.Dart_InitializeApiDL(api)
}

type Work struct {
	a int64
	b int64
}

func SendToPort(port int64, msg int64) {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64

	var pwork unsafe.Pointer
	C.GetWork(&pwork)
	work := *(*Work)(pwork)

	unsafePtr := (*int64)(unsafe.Pointer(&work))

	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = C.int64_t(*unsafePtr)

	C.GoDart_PostCObject(C.int64_t(port), &obj)
}
