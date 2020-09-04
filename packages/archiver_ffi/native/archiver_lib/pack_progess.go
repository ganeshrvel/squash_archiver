package main

import (
	"fmt"
	rxgo "github.com/ReactiveX/RxGo"
	"time"
)

func initPackingProgress(totalFiles int) (*PackingProgressInfo, *chan rxgo.Item) {
	pInfo := PackingProgressInfo{
		startTime:          time.Now(),
		totalFiles:         totalFiles,
		progressCount:      0,
		currentFilename:    "",
		progressPercentage: 0,
	}

	ch := make(chan rxgo.Item)

	observable := rxgo.FromChannel(ch)

	observable.ForEach(func(v interface{}) {
		fmt.Printf("received: %v\n", v)
	}, func(err error) {
		fmt.Printf("error: %e\n", err)
	}, func() {
		elapsed := time.Since(pInfo.startTime)

		fmt.Println("observable is closed")
		fmt.Println("Time taken to create the archive: %s", elapsed)
	})

	return &pInfo, &ch
}
func (pInfo *PackingProgressInfo) closePacking(ch *chan rxgo.Item, totalFiles int) {
	pInfo.totalFiles = totalFiles
	pInfo.progressCount = totalFiles
	pInfo.currentFilename = ""
	pInfo.progressPercentage = 100.00

	*ch <- rxgo.Of(pInfo)

	defer close(*ch)
}

func (pInfo *PackingProgressInfo) packingProgress(ch *chan rxgo.Item, totalFiles int, absolutePath string) {
	progressCount := pInfo.progressCount + 1
	progressPercentage := Percent(float32(progressCount), float32(totalFiles))

	pInfo.totalFiles = totalFiles
	pInfo.progressCount = progressCount
	pInfo.currentFilename = absolutePath
	pInfo.progressPercentage = progressPercentage

	*ch <- rxgo.Of(pInfo)
}
