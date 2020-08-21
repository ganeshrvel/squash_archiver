package main

import (
	"fmt"
	"log"
	"os"
	"testing"
)

func testRead(t *testing.T) {
	t.Error()
}

func getTestAssets(filename string) string {
	currentDir, err := os.Getwd()

	if err != nil {
		log.Panicf("test path not found: %s\n", filename)
	}

	resultPath := fmt.Sprintf("%s/tests/archiver-test-mocks/%s", currentDir, filename)

	if exist := fileExists(resultPath); !exist {
		log.Panicf("test file does not exist: %s\n", resultPath)
	}

	return resultPath
}

func TestListArchiveListDirectoryPathError(t *testing.T) {
	t.Log("'listDirectoryPath - it should throw an error")

	filename := getTestAssets("test.zip")

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist: %s\n", filename)

		return
	}

	_metaObj := &ArchiveMeta{filename: filename}

	_listObj := &ArchiveRead{
		password:          "",
		listDirectoryPath: "abc/",
		recursive:         true,
		orderBy:           OrderByName,
		orderDir:          OrderDirAsc,
	}

	_, err := getArchiveFileList(_metaObj, _listObj)

	if err == nil {
		t.Error()
	}
}

func TestListArchiveListDirectoryPath(t *testing.T) {
	t.Log("'listDirectoryPath - it should not throw an error")

	filename := getTestAssets("test.zip")

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist: %s\n", filename)

		return
	}

	_metaObj := &ArchiveMeta{filename: filename}

	_listObj := &ArchiveRead{
		password:          "",
		listDirectoryPath: "hey/",
		recursive:         true,
		orderBy:           OrderByName,
		orderDir:          OrderDirAsc,
	}

	_, err := getArchiveFileList(_metaObj, _listObj)

	if err != nil {
		return
	}

	t.Error()
}
