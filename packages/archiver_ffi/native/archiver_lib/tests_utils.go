package main

import (
	"fmt"
	"log"
	"os"
)

func getTestMocksAsset(_filePath string) string {
	currentDir, err := os.Getwd()

	if err != nil {
		log.Panicf("\nunable to fetch the current directory: %s\n", currentDir)
	}

	resultPath := fmt.Sprintf("%s/tests/mocks/", currentDir)

	resultPath = fmt.Sprintf("%s%s", resultPath, _filePath)

	if exist := exists(resultPath); !exist {
		log.Panicf("\nthe 'mocks' asset not found: %s\n", resultPath)
	}

	return resultPath
}

func newTestMocksAsset(_filePath string) string {
	currentDir, err := os.Getwd()

	if err != nil {
		log.Panicf("\nunable to fetch the current directory: %s\n", currentDir)
	}

	resultPath := fmt.Sprintf("%s/tests/mocks/", currentDir)

	resultPath = fmt.Sprintf("%s%s", resultPath, _filePath)

	return resultPath
}

func newTempMocksAsset(_filePath string) string {
	currentDir, err := os.Getwd()

	if err != nil {
		log.Panicf("\nunable to fetch the current directory: %s\n", currentDir)
	}

	resultPath := fmt.Sprintf("%s/tests/mocks-build/", currentDir)

	if exist := isDir(resultPath); !exist {
		_, err := os.Create(resultPath)

		if err != nil {
			log.Panicf("\n'mocks-build' directory not found: %s\n", resultPath)
		}
	}

	resultPath = fmt.Sprintf("%s%s", resultPath, _filePath)

	return resultPath
}
