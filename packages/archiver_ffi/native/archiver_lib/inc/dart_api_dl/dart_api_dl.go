package dart_api_dl

import "C"
import (
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

	typedef struct UserStruct{
		char *email;
		int64_t id;
	}UserStruct;

	int64_t GetUser(void **ppUser, char *email, int64_t id) {
		UserStruct *pUser = (UserStruct *)malloc(sizeof(UserStruct));
		pUser->email=email;
		pUser->id=id;

		*ppUser = pUser;

		int64_t ptr = (int64_t)pUser;

		return ptr;
	}

	void clearUserStructMemory(UserStruct pUser) {
		free(&pUser.email);
		free(&pUser.id);
		free(&pUser);
	}
*/
import "C"

func Init(api unsafe.Pointer) C.long {
	return C.Dart_InitializeApiDL(api)
}

func CloseNativePort(port int64) bool {
	result := C.GoDart_CloseNativePort(C.int64_t(port))

	return (bool)(result)
}

func SendWorkToPort(port int64, msg int64) {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64

	itemArr := []*C.char{C.CString("Item 1"), C.CString("Item 2"), C.CString("Item 3")}

	var pwork unsafe.Pointer
	ptrAddr := C.GetWork(&pwork, C.CString("Smith"), C.int64_t(msg), &itemArr[0])

	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = ptrAddr

	C.GoDart_PostCObject(C.int64_t(port), &obj)
}

func FreeWorkStructMemory(pointer *int64) {
	ptr := (*C.struct_WorkStruct)(unsafe.Pointer(pointer))
	C.clearWorkStructMemory(*ptr)
}

func SendUserToPort(port int64, msg int64) {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64

	var pUser unsafe.Pointer
	ptrAddr := C.GetUser(&pUser, C.CString("jhon@doe.com"), C.int64_t(msg))

	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = ptrAddr

	C.GoDart_PostCObject(C.int64_t(port), &obj)
}

func FreeUserStructMemory(pointer *int64) {
	ptr := (*C.struct_UserStruct)(unsafe.Pointer(pointer))
	C.clearUserStructMemory(*ptr)
}
