package main

import (
	. "github.com/smartystreets/goconvey/convey"
	"github.com/yeka/zip"
	"testing"
)

func _testListingPackedArchive(_metaObj *ArchiveMeta, password string, customAssertionPathlist []string) {
	Convey("recursive=true | Asc - it should not throw an error", func() {
		_listObj := &ArchiveRead{
			password:          password,
			listDirectoryPath: "",
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

		var assertionArr []string

		if customAssertionPathlist != nil {
			assertionArr = customAssertionPathlist
		} else {
			assertionArr = []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}
		}

		So(itemsArr, ShouldResemble, assertionArr)
	})
}

func _testPacking(_metaObj *ArchiveMeta, password string) {
	Convey("encryptionMethod=nil | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)
	})

	Convey("empty password | encryptionMethod=zip.StandardEncryption | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			encryptionMethod:  zip.StandardEncryption,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			_testListingPackedArchive(_metaObj, password, nil)
		})
	})

	Convey("gitIgnorePattern | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			gitIgnorePattern:  []string{"b.txt"},
			encryptionMethod:  zip.StandardEncryption,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionArr := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/3/", "mock_dir1/3/2/"}

			_testListingPackedArchive(_metaObj, password, assertionArr)
		})
	})
}

func TestPacking(t *testing.T) {
	Convey("Packing | No encryption - ZIP", t, func() {
		filename := newTempMocksAsset("arc_test_pack.zip")

		_metaObj := &ArchiveMeta{filename: filename}

		_testPacking(_metaObj, "")
	})
}
