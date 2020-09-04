package main

import (
	. "github.com/smartystreets/goconvey/convey"
	"log"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func _testListingUnpackedArchive(_metaObj *ArchiveMeta, _unpackObj *ArchiveUnpack, password string, assertionArr []string) {
	destination := _unpackObj.destination

	Convey("recursive=true | Asc - it should not throw an error", func() {
		_listObj := &ArchiveRead{
			password:          password,
			listDirectoryPath: "",
			recursive:         true,
			orderBy:           OrderByFullPath,
			orderDir:          OrderDirAsc,
			gitIgnorePattern:  _unpackObj.gitIgnorePattern,
		}

		result, err := getArchiveFileList(_metaObj, _listObj)

		So(err, ShouldBeNil)

		var itemsArr []string

		for _, item := range result {
			itemsArr = append(itemsArr, item.FullPath)
		}

		So(itemsArr, ShouldResemble, assertionArr)

	})

	Convey("Fetch  - it should not throw an error", func() {
		var filePathList []filePathListSortInfo

		err := filepath.Walk(destination, func(path string, info os.FileInfo, err error) error {
			if destination == path {
				return nil
			}

			var pathSplitted [2]string

			if !info.IsDir() {
				pathSplitted = [2]string{filepath.Dir(path), filepath.Base(path)}
			} else {
				path = fixDirSlash(true, path)
				_dir := filepath.Dir(path)

				pathSplitted = [2]string{_dir, ""}
			}

			filePathList = append(filePathList, filePathListSortInfo{
				IsDir:         info.IsDir(),
				FullPath:      path,
				splittedPaths: pathSplitted,
			})

			return nil
		})
		if err != nil {
			log.Fatal(err)
		}

		_sortPath(&filePathList, OrderDirAsc)

		var itemsArr []string

		for _, x := range filePathList {
			_path := strings.Replace(x.FullPath, destination, "", -1)
			_path = strings.TrimLeft(_path, "/")

			itemsArr = append(itemsArr, _path)
		}

		So(itemsArr, ShouldResemble, assertionArr)
	})
}

func _testUnpacking(_metaObj *ArchiveMeta, password string) {
	Convey("Warm up test | It should not throw an error", func() {
		_destination := newTempMocksDir("mock_test_file1", true)

		_unpackObj := &ArchiveUnpack{
			password:         password,
			fileList:         []string{},
			gitIgnorePattern: []string{},
			destination:      _destination,
		}

		err := startUnpacking(_metaObj, _unpackObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionArr := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

			_testListingUnpackedArchive(_metaObj, _unpackObj, password, assertionArr)
		})
	})

	Convey("gitIgnore | It should not throw an error", func() {
		_destination := newTempMocksDir("mock_test_file1", true)

		_unpackObj := &ArchiveUnpack{
			password:         password,
			fileList:         []string{},
			gitIgnorePattern: []string{"a.txt"},
			destination:      _destination,
		}

		err := startUnpacking(_metaObj, _unpackObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionArr := []string{"mock_dir1/", "mock_dir1/1/", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

			_testListingUnpackedArchive(_metaObj, _unpackObj, password, assertionArr)
		})
	})
}

func TestUnpacking(t *testing.T) {
	//if testing.Short() {
	//	t.Skip("skipping 'TestUnpacking' testing in short mode")
	//}

	Convey("Packing | No encryption - ZIP", t, func() {
		filename := getTestMocksAsset("mock_test_file1.zip")

		_metaObj := &ArchiveMeta{filename: filename}

		_testUnpacking(_metaObj, "")
	})
}
