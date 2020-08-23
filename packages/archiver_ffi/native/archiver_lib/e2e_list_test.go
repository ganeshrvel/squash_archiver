package main

import (
	"fmt"
	. "github.com/smartystreets/goconvey/convey"
	"log"
	"os"
	"testing"
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

func TestArchiveListing(t *testing.T) {
	Convey("Archive Listing - ZIP", t, func() {
		filename := getTestMocksFile("mock_test_file1.zip")
		_metaObj := &ArchiveMeta{filename: filename}

		Convey("Wrong listDirectoryPath - it should throw an error", func() {

			_listObj := &ArchiveRead{
				password:          "",
				listDirectoryPath: "qwerty/",
				recursive:         true,
				orderBy:           OrderByName,
				orderDir:          OrderDirAsc,
			}

			_, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeError)
		})

		Convey("OrderByFullPath | Asc - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				password:          "",
				listDirectoryPath: "mock_dir1/",
				recursive:         true,
				orderBy:           OrderByFullPath,
				orderDir:          OrderDirAsc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt", "mock_dir1/3/b.txt", "mock_dir1/a.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("OrderByFullPath | Desc - it should not throw an error", func() {

			_listObj := &ArchiveRead{
				password:          "",
				listDirectoryPath: "mock_dir1/",
				recursive:         true,
				orderBy:           OrderByFullPath,
				orderDir:          OrderDirDesc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/a.txt", "mock_dir1/3/b.txt", "mock_dir1/3/2/b.txt", "mock_dir1/3/2/", "mock_dir1/3/", "mock_dir1/2/b.txt", "mock_dir1/2/", "mock_dir1/1/a.txt", "mock_dir1/1/", "mock_dir1/"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("listDirectoryPath='' | recursive=true - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				password:          "",
				listDirectoryPath: "",
				recursive:         true,
				orderBy:           OrderByFullPath,
				orderDir:          OrderDirDesc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/a.txt", "mock_dir1/3/b.txt", "mock_dir1/3/2/b.txt", "mock_dir1/3/2/", "mock_dir1/3/", "mock_dir1/2/b.txt", "mock_dir1/2/", "mock_dir1/1/a.txt", "mock_dir1/1/", "mock_dir1/"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("listDirectoryPath='' | recursive=false - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				password:          "",
				listDirectoryPath: "",
				recursive:         false,
				orderBy:           OrderByFullPath,
				orderDir:          OrderDirDesc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/"}

			So(itemsArr, ShouldResemble, assertionArr)
		})
	})
}

/*

encjson, _ := json.Marshal(itemsArr)
fmt.Println(string(encjson))

*/
