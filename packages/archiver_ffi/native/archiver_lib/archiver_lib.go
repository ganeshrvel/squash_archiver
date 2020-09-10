package main

//import (
//	"C"
//)
//
//////export InitializeDartApi
////func InitializeDartApi(api unsafe.Pointer) {
////	dart_api_dl.Init(api)
////}
////
//////export CloseNativeDartPort
////func CloseNativeDartPort(port int64) bool {
////	return dart_api_dl.CloseNativePort(port)
////}

////export StartWork
//func StartWork(port int64) {
//	//fmt.Println("Go: Starting some 'Work' asynchronous work")
//
//	go func(port int64) {
//		var counter int64
//		for {
//			time.Sleep(2 * time.Second)
//			//fmt.Println("GO: 2 'Work' seconds passed")
//			counter++
//			dart_api_dl.SendWorkToPort(port, counter)
//		}
//	}(port)
//
//	//fmt.Println("Go: Returning 'Work' to Dart")
//}
//
////export FreeWorkStructMemory
//func FreeWorkStructMemory(pointer *int64) {
//	dart_api_dl.FreeWorkStructMemory(pointer)
//}
//
////export StartUser
//func StartUser(port int64) {
//	//fmt.Println("Go: Starting 'User' asynchronous call")
//
//	go func(port int64) {
//		var counter int64
//		for {
//			time.Sleep(3 * time.Second)
//			//fmt.Println("GO: 2 'User' seconds passed")
//			counter++
//			dart_api_dl.SendUserToPort(port, counter)
//
//		}
//	}(port)
//
//	//fmt.Println("Go: Returning 'User' to Dart")
//}
//
////export FreeUserStructMemory
//func FreeUserStructMemory(pointer *int64) {
//	dart_api_dl.FreeUserStructMemory(pointer)
//}
//
///*func main() {
//
//}
//*/
