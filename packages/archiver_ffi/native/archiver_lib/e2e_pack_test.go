package main

import (
	. "github.com/smartystreets/goconvey/convey"
	"github.com/yeka/zip"
	"testing"
)

func _testListingPackedArchive(_metaObj *ArchiveMeta, password string) {
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

		assertionArr := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

		_ = []string{"mock_dir1/", "mock_dir1/1", "mock_dir1/2", "mock_dir1/3", "mock_dir1/a.txt", "mock_dir1/1/a.txt", "mock_dir1/2/b.txt", "mock_dir1/3/2", "mock_dir1/3/b.txt", "mock_dir1/3/2/b.txt"}

		So(itemsArr, ShouldResemble, assertionArr)
	})
}

func _testPacking(_metaObj *ArchiveMeta, password string) {

	Convey("encryptionMethod=nil | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			gitIgnorePattern:  "",
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)
	})

	Convey("It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			gitIgnorePattern:  "", //todo
			encryptionMethod:  zip.StandardEncryption,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("Packed Archive listing", func() {
			_testListingPackedArchive(_metaObj, password)
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
