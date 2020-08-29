package main

import (
	"fmt"
	. "github.com/smartystreets/goconvey/convey"
	"log"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

type ListTestType string

const (
	ListTestTypeEnc       ListTestType = "enc"
	ListTestTypeNonEnc    ListTestType = "non_enc"
	ListTestTypeMacNonEnc ListTestType = "mac_non_enc"
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

func _testArchiveListing(_metaObj *ArchiveMeta, password string, listTestType ListTestType) {
	//Convey("General tests", func() {
	//	Convey("Incorrect listDirectoryPath - it should throw an error", func() {
	//
	//		_listObj := &ArchiveRead{
	//			password:          password,
	//			listDirectoryPath: "qwerty/",
	//			recursive:         true,
	//			orderBy:           OrderByName,
	//			orderDir:          OrderDirAsc,
	//		}
	//
	//		_, err := getArchiveFileList(_metaObj, _listObj)
	//
	//		So(err, ShouldBeError)
	//	})
	//})
	//
	//Convey("OrderByName", func() {
	//	Convey("Asc | recursive=false - it should not throw an error", func() {
	//		_listObj := &ArchiveRead{
	//			password:          password,
	//			listDirectoryPath: "mock_dir1/",
	//			recursive:         false,
	//			orderBy:           OrderByName,
	//			orderDir:          OrderDirAsc,
	//		}
	//
	//		result, err := getArchiveFileList(_metaObj, _listObj)
	//
	//		So(err, ShouldBeNil)
	//
	//		var itemsArr []string
	//
	//		for _, item := range result {
	//			itemsArr = append(itemsArr, item.FullPath)
	//		}
	//
	//		assertionArr := []string{"mock_dir1/1/", "mock_dir1/2/", "mock_dir1/3/", "mock_dir1/a.txt"}
	//
	//		So(itemsArr, ShouldResemble, assertionArr)
	//	})
	//
	//	Convey("Desc | recursive=false | 1 - it should not throw an error", func() {
	//		_listObj := &ArchiveRead{
	//			password:          password,
	//			listDirectoryPath: "mock_dir1/3/",
	//			recursive:         false,
	//			orderBy:           OrderByName,
	//			orderDir:          OrderDirDesc,
	//		}
	//
	//		result, err := getArchiveFileList(_metaObj, _listObj)
	//
	//		So(err, ShouldBeNil)
	//
	//		var itemsArr []string
	//
	//		for _, item := range result {
	//			itemsArr = append(itemsArr, item.FullPath)
	//		}
	//
	//		assertionArr := []string{"mock_dir1/3/b.txt", "mock_dir1/3/2/"}
	//
	//		So(itemsArr, ShouldResemble, assertionArr)
	//	})
	//
	//	Convey("Desc | recursive=false | 2 - it should not throw an error", func() {
	//		_listObj := &ArchiveRead{
	//			password:          password,
	//			listDirectoryPath: "mock_dir1/3",
	//			recursive:         false,
	//			orderBy:           OrderByName,
	//			orderDir:          OrderDirDesc,
	//		}
	//
	//		result, err := getArchiveFileList(_metaObj, _listObj)
	//
	//		So(err, ShouldBeNil)
	//
	//		var itemsArr []string
	//
	//		for _, item := range result {
	//			itemsArr = append(itemsArr, item.FullPath)
	//		}
	//
	//		assertionArr := []string{"mock_dir1/3/b.txt", "mock_dir1/3/2/"}
	//
	//		So(itemsArr, ShouldResemble, assertionArr)
	//	})
	//
	//	Convey("Desc | recursive=true | 1 - it should not throw an error", func() {
	//		_listObj := &ArchiveRead{
	//			password:          password,
	//			listDirectoryPath: "mock_dir1/3",
	//			recursive:         true,
	//			orderBy:           OrderByName,
	//			orderDir:          OrderDirDesc,
	//		}
	//
	//		result, err := getArchiveFileList(_metaObj, _listObj)
	//
	//		So(err, ShouldBeNil)
	//
	//		var itemsArr []string
	//
	//		for _, item := range result {
	//			itemsArr = append(itemsArr, item.FullPath)
	//		}
	//
	//		assertionArr := []string{"mock_dir1/3/b.txt", "mock_dir1/3/2/b.txt", "mock_dir1/3/2/"}
	//
	//		So(itemsArr, ShouldResemble, assertionArr)
	//	})
	//})
	//
	//Convey("empty listDirectoryPath", func() {
	//	// structure of archiving in macOS might be a bit different
	//	if listTestType == ListTestTypeMacNonEnc {
	//		Convey("recursive=true | Asc - it should not throw an error", func() {
	//			_listObj := &ArchiveRead{
	//				password:          password,
	//				listDirectoryPath: "",
	//				recursive:         true,
	//				orderBy:           OrderByName,
	//				orderDir:          OrderDirAsc,
	//			}
	//
	//			result, err := getArchiveFileList(_metaObj, _listObj)
	//
	//			So(err, ShouldBeNil)
	//
	//			var itemsArr []string
	//
	//			for _, item := range result {
	//				itemsArr = append(itemsArr, item.FullPath)
	//			}
	//
	//			assertionArr := []string{"mock_dir1/1/", "mock_dir1/2/", "mock_dir1/3/2/", "mock_dir1/3/", "mock_dir1/a.txt", "mock_dir1/1/a.txt", "mock_dir1/3/b.txt", "mock_dir1/2/b.txt", "mock_dir1/3/2/b.txt", "mock_dir1/"}
	//
	//			So(itemsArr, ShouldResemble, assertionArr)
	//		})
	//	} else {
	//		Convey("recursive=true | Asc - it should not throw an error", func() {
	//			_listObj := &ArchiveRead{
	//				password:          password,
	//				listDirectoryPath: "",
	//				recursive:         true,
	//				orderBy:           OrderByName,
	//				orderDir:          OrderDirAsc,
	//			}
	//
	//			result, err := getArchiveFileList(_metaObj, _listObj)
	//
	//			So(err, ShouldBeNil)
	//
	//			var itemsArr []string
	//
	//			for _, item := range result {
	//				itemsArr = append(itemsArr, item.FullPath)
	//			}
	//
	//			assertionArr := []string{"mock_dir1/1/", "mock_dir1/3/2/", "mock_dir1/2/", "mock_dir1/3/", "mock_dir1/a.txt", "mock_dir1/1/a.txt", "mock_dir1/3/b.txt", "mock_dir1/3/2/b.txt", "mock_dir1/2/b.txt", "mock_dir1/"}
	//
	//			So(itemsArr, ShouldResemble, assertionArr)
	//		})
	//	}
	//
	//	Convey("recursive=false | Desc - it should not throw an error", func() {
	//		_listObj := &ArchiveRead{
	//			password:          password,
	//			listDirectoryPath: "",
	//			recursive:         false,
	//			orderBy:           OrderByName,
	//			orderDir:          OrderDirDesc,
	//		}
	//
	//		result, err := getArchiveFileList(_metaObj, _listObj)
	//
	//		So(err, ShouldBeNil)
	//
	//		var itemsArr []string
	//
	//		for _, item := range result {
	//			itemsArr = append(itemsArr, item.FullPath)
	//		}
	//
	//		assertionArr := []string{"mock_dir1/"}
	//
	//		So(itemsArr, ShouldResemble, assertionArr)
	//	})
	//})

	Convey("OrderByFullPath", func() {
		Convey("Asc | recursive=true | 1 - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				password:          password,
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

			assertionArr := []string{"mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})
		//
		////Convey("Asc | recursive=true | 2 - it should not throw an error", func() {
		//
		//	_listObj := &ArchiveRead{
		//		password:          password,
		//		listDirectoryPath: "mock_dir1/3",
		//		recursive:         true,
		//		orderBy:           OrderByFullPath,
		//		orderDir:          OrderDirAsc,
		//	}
		//
		//	result, err := getArchiveFileList(_metaObj, _listObj)
		//
		//	So(err, ShouldBeNil)
		//
		//	var itemsArr []string
		//
		//	for _, item := range result {
		//		itemsArr = append(itemsArr, item.FullPath)
		//	}
		//
		//	pretty.Println("\n", itemsArr)
		//
		//	assertionArr := []string{"mock_dir1/3/2/", "mock_dir1/3/2/b.txt", "mock_dir1/3/b.txt"}
		//
		//	So(itemsArr, ShouldResemble, assertionArr)
		//})

		//Convey("Desc - it should not throw an error", func() {
		//	_listObj := &ArchiveRead{
		//		password:          password,
		//		listDirectoryPath: "mock_dir1/",
		//		recursive:         true,
		//		orderBy:           OrderByFullPath,
		//		orderDir:          OrderDirDesc,
		//	}
		//
		//	result, err := getArchiveFileList(_metaObj, _listObj)
		//
		//	So(err, ShouldBeNil)
		//
		//	var itemsArr []string
		//
		//	for _, item := range result {
		//		itemsArr = append(itemsArr, item.FullPath)
		//	}
		//
		//	assertionArr := []string{"mock_dir1/a.txt", "mock_dir1/3/b.txt", "mock_dir1/3/2/b.txt", "mock_dir1/3/2/", "mock_dir1/3/", "mock_dir1/2/b.txt", "mock_dir1/2/", "mock_dir1/1/a.txt", "mock_dir1/1/"}
		//
		//	So(itemsArr, ShouldResemble, assertionArr)
		//})

	})

}

func _testOrderByFullPathListing() {
	Convey("OrderByFullPath", func() {
		Convey("Asc | 1 - it should not throw an error", func() {
			var filePathList []filePathListSortInfo

			list := []string{"A/file1.txt",
				"A/B/C/D/file3.txt",
				"A/B/file2.txt",
				"A/B/file1.txt",
				"A/B/123.txt",
				"A/B/C/D/file1.txt",
				"A/file2.txt",
				"A/B/",
				"A/W/X/Y/Z/file1.txt",
				"A/W/file1.txt",
				"A/W/X/file1.txt",
				"A/file3.txt",
				"A/B/C/file1.txt",
				"mock_dir1/3/2/",
				"mock_dir1/3/2/b/",
				"mock_dir1/2/",
				"mock_dir1/1/",
				"mock_dir1/1/2/",
				"mock_dir1/1/a.txt",
				"mock_dir1/3/b.txt",
				"A/W/X/Y/file1.txt",
				"A/B/file2.txt"}

			for _, x := range list {
				isDir := !strings.HasSuffix(x, ".txt")

				var pathSplitted [2]string

				if !isDir {
					pathSplitted = [2]string{filepath.Dir(x), filepath.Base(x)}
				} else {
					pathSplitted = [2]string{filepath.Dir(x), ""}
				}

				filePathList = append(filePathList, filePathListSortInfo{
					IsDir:         isDir,
					FullPath:      x,
					splittedPaths: pathSplitted,
				})
			}

			_sortPath(&filePathList, OrderDirAsc)

			assertionArr := []string{"A/file1.txt", "A/file2.txt", "A/file3.txt", "A/B/", "A/B/123.txt", "A/B/file1.txt", "A/B/file2.txt", "A/B/file2.txt", "A/B/C/file1.txt", "A/B/C/D/file1.txt", "A/B/C/D/file3.txt", "A/W/file1.txt", "A/W/X/file1.txt", "A/W/X/Y/file1.txt", "A/W/X/Y/Z/file1.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/1/2/", "mock_dir1/2/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b/"}

			var itemsArr []string

			for _, x := range filePathList {
				itemsArr = append(itemsArr, x.FullPath)
			}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("Asc | 2 - it should not throw an error", func() {
			var filePathList []filePathListSortInfo

			list := []string{"/A/file1.txt",
				"/A/B/C/D/file3.txt",
				"/A/B/file2.txt",
				"/A/B/file1.txt",
				"/A/B/123.txt",
				"/A/B/C/D/file1.txt",
				"/A/file2.txt",
				"/A/B/",
				"/A/W/X/Y/Z/file1.txt",
				"/A/W/file1.txt",
				"/A/W/X/file1.txt",
				"/A/file3.txt",
				"/A/B/C/file1.txt",
				"/mock_dir1/3/2/",
				"/mock_dir1/3/2/b/",
				"/mock_dir1/2/",
				"/mock_dir1/1/",
				"/mock_dir1/1/2/",
				"/mock_dir1/1/a.txt",
				"/mock_dir1/3/b.txt",
				"/A/W/X/Y/file1.txt",
				"/A/B/file2.txt"}

			for _, x := range list {
				isDir := !strings.HasSuffix(x, ".txt")

				var pathSplitted [2]string

				if !isDir {
					pathSplitted = [2]string{filepath.Dir(x), filepath.Base(x)}
				} else {
					pathSplitted = [2]string{filepath.Dir(x), ""}
				}

				filePathList = append(filePathList, filePathListSortInfo{
					IsDir:         isDir,
					FullPath:      x,
					splittedPaths: pathSplitted,
				})
			}

			_sortPath(&filePathList, OrderDirDesc)

			assertionArr := []string{"/mock_dir1/3/2/b/", "/mock_dir1/3/2/", "/mock_dir1/3/b.txt", "/mock_dir1/2/", "/mock_dir1/1/2/", "/mock_dir1/1/a.txt", "/mock_dir1/1/", "/A/W/X/Y/Z/file1.txt", "/A/W/X/Y/file1.txt", "/A/W/X/file1.txt", "/A/W/file1.txt", "/A/B/C/D/file3.txt", "/A/B/C/D/file1.txt", "/A/B/C/file1.txt", "/A/B/file2.txt", "/A/B/file2.txt", "/A/B/file1.txt", "/A/B/123.txt", "/A/B/", "/A/file3.txt", "/A/file2.txt", "/A/file1.txt"}

			var itemsArr []string

			for _, x := range filePathList {
				itemsArr = append(itemsArr, x.FullPath)
			}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("Desc | 1 - it should not throw an error", func() {
			var filePathList []filePathListSortInfo

			list := []string{"A/file1.txt",
				"A/B/C/D/file3.txt",
				"A/B/file2.txt",
				"A/B/file1.txt",
				"A/B/123.txt",
				"A/B/C/D/file1.txt",
				"A/file2.txt",
				"A/B/",
				"A/W/X/Y/Z/file1.txt",
				"A/W/file1.txt",
				"A/W/X/file1.txt",
				"A/file3.txt",
				"A/B/C/file1.txt",
				"mock_dir1/3/2/",
				"mock_dir1/3/2/b/",
				"mock_dir1/2/",
				"mock_dir1/1/",
				"mock_dir1/1/2/",
				"mock_dir1/1/a.txt",
				"mock_dir1/3/b.txt",
				"A/W/X/Y/file1.txt",
				"A/B/file2.txt"}

			for _, x := range list {
				isDir := !strings.HasSuffix(x, ".txt")

				var pathSplitted [2]string

				if !isDir {
					pathSplitted = [2]string{filepath.Dir(x), filepath.Base(x)}
				} else {
					pathSplitted = [2]string{filepath.Dir(x), ""}
				}

				filePathList = append(filePathList, filePathListSortInfo{
					IsDir:         isDir,
					FullPath:      x,
					splittedPaths: pathSplitted,
				})
			}

			_sortPath(&filePathList, OrderDirDesc)

			assertionArr := []string{"mock_dir1/3/2/b/", "mock_dir1/3/2/", "mock_dir1/3/b.txt", "mock_dir1/2/", "mock_dir1/1/2/", "mock_dir1/1/a.txt", "mock_dir1/1/", "A/W/X/Y/Z/file1.txt", "A/W/X/Y/file1.txt", "A/W/X/file1.txt", "A/W/file1.txt", "A/B/C/D/file3.txt", "A/B/C/D/file1.txt", "A/B/C/file1.txt", "A/B/file2.txt", "A/B/file2.txt", "A/B/file1.txt", "A/B/123.txt", "A/B/", "A/file3.txt", "A/file2.txt", "A/file1.txt"}

			var itemsArr []string

			for _, x := range filePathList {
				itemsArr = append(itemsArr, x.FullPath)
			}

			So(itemsArr, ShouldResemble, assertionArr)
		})
	})
}

func TestArchiveListing(t *testing.T) {
	Convey("Testing OrderByFullPath", t, func() {
		_testOrderByFullPathListing()
	})

	Convey("macOS Compressed Archive Listing - ZIP", t, func() {
		filename := getTestMocksFile("mock_mac_test_file1.zip")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj, "", ListTestTypeMacNonEnc)
	})

	/*	Convey("Archive Listing - ZIP", t, func() {
			filename := getTestMocksFile("mock_test_file1.zip")
			_metaObj := &ArchiveMeta{filename: filename}

			_testArchiveListing(_metaObj, "", ListTestTypeNonEnc)
		})

		Convey("Archive Listing - Encrypted ZIP", t, func() {
			filename := getTestMocksFile("mock_enc_test_file1.zip")
			_metaObj := &ArchiveMeta{filename: filename}

			_testArchiveListing(_metaObj, "1234567", ListTestTypeEnc)
		})

		Convey("Archive Listing - tar.gz", t, func() {
			filename := getTestMocksFile("mock_test_file1.tar.gz")
			_metaObj := &ArchiveMeta{filename: filename}

			_testArchiveListing(_metaObj, "", ListTestTypeMacNonEnc)
		})*/
}
