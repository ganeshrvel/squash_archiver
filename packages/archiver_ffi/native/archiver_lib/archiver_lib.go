package main

import (
	"./dart_api_dl"
	"C"
	"fmt"
	"time"
	"unsafe"
)

//export InitializeDartApi
func InitializeDartApi(api unsafe.Pointer) {
	dart_api_dl.Init(api)
}

var quit = make(chan int64)

//export StartWork
func StartWork(port int64) {
	fmt.Println("Go: Starting some asynchronous work")

	go func(port int64) {
		var counter int64
		for {
			time.Sleep(2 * time.Second)
			fmt.Println("GO: 2 seconds passed")
			counter++
			dart_api_dl.SendToPort(port, counter)

			/*if counter > 3 {
				quit <- 3
			}*/
		}
	}(port)

	fmt.Println("Go: Returning to Dart")
}

//export StopWork
func StopWork(port int64) {
	fmt.Println("Go: Stopping some asynchronous work")

	quit <- 3

	fmt.Println("Go: Stopped the Go work")
}

//export FreeWorkStructMemory
func FreeWorkStructMemory(pointer *int64) {
	dart_api_dl.FreeWorkStructMemory(pointer)
}

// Unused
func main() {

}
