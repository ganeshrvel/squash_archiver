package main

import (
	"fmt"
	"log"
	"os"
)

func getTestMocksFile(filename string) string {
	currentDir, err := os.Getwd()

	if err != nil {
		log.Panicf("unable to fetch the current directory: %s\n", currentDir)
	}

	resultPath := fmt.Sprintf("%s/tests/mocks/", currentDir)

	if exist := isDir(resultPath); !exist {
		_, err := os.Create(resultPath)

		if err != nil {
			log.Panicf("'mocks' directory not found: %s\n", resultPath)
		}
	}

	resultPath = fmt.Sprintf("%s%s", resultPath, filename)

	if exist := fileExists(resultPath); !exist {
		log.Panicf("the 'mocks' file not found: %s\n", resultPath)
	}

	return resultPath
}
func getTestMocksBuildDir(filename string) string {
	currentDir, err := os.Getwd()

	if err != nil {
		log.Panicf("unable to fetch the current directory: %s\n", currentDir)
	}

	resultPath := fmt.Sprintf("%s/tests/mocks-build/", currentDir)

	if exist := isDir(resultPath); !exist {
		_, err := os.Create(resultPath)

		if err != nil {
			log.Panicf("'mocks-build' directory not found: %s\n", resultPath)
		}
	}

	resultPath = fmt.Sprintf("%s%s", resultPath, filename)

	if exist := fileExists(resultPath); !exist {
		log.Panicf("the 'mocks-build' file not found: %s\n", resultPath)
	}

	return resultPath
}
