package main

import (
	. "github.com/smartystreets/goconvey/convey"
	"github.com/yeka/zip"
	"testing"
)

func _testListingPackedArchive(_metaObj *ArchiveMeta, password string, assertionArr []string) {
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

		So(itemsArr, ShouldResemble, assertionArr)
	})
}

func _testPacking(_metaObj *ArchiveMeta, password string, encryptionMethod zip.EncryptionMethod) {
	Convey("gitIgnorePattern | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			encryptionMethod:  encryptionMethod,
			gitIgnorePattern:  []string{"b.txt"},
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionArr := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/3/", "mock_dir1/3/2/"}

			_testListingPackedArchive(_metaObj, password, assertionArr)
		})
	})

	Convey("Single path in 'fileList' | selected - a directory  | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionArr := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionArr)
		})
	})

	Convey("Single path in 'fileList' | selected - a file  | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/a.txt")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"a.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - Multiple directories | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1")
		path2 := getTestMocksAsset("mock_dir2")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt", "mock_dir2/", "mock_dir2/a.txt", "mock_dir2/1/", "mock_dir2/1/a.txt", "mock_dir2/2/", "mock_dir2/2/b.txt", "mock_dir2/3/", "mock_dir2/3/b.txt", "mock_dir2/3/2/", "mock_dir2/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - Multiple files | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir3/a.txt")
		path2 := getTestMocksAsset("mock_dir3/b.txt")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"a.txt", "b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - single file and a single directory | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/a.txt")
		path2 := getTestMocksAsset("mock_dir1/1/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"a.txt", "1/", "1/a.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - single file and multiple directories | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/a.txt")
		path2 := getTestMocksAsset("mock_dir1/1/")
		path3 := getTestMocksAsset("mock_dir1/2/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2, path3},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"a.txt", "1/", "1/a.txt", "2/", "2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - multiple files and multiple directories | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir3/a.txt")
		path2 := getTestMocksAsset("mock_dir3/b.txt")
		path3 := getTestMocksAsset("mock_dir3/1/")
		path4 := getTestMocksAsset("mock_dir3/2/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2, path3, path4},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"a.txt", "b.txt", "1/", "1/a.txt", "2/", "2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Different levels of parent paths | Multiple paths in 'fileList' | selected - two files | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/a.txt")
		path2 := getTestMocksAsset("mock_dir1/1/a.txt")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"a.txt", "1/", "1/a.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Different levels of parent paths | Multiple paths in 'fileList' | selected - 1 file and 1 directory | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/a.txt")
		path2 := getTestMocksAsset("mock_dir2/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir2/", "mock_dir2/a.txt", "mock_dir2/1/", "mock_dir2/1/a.txt", "mock_dir2/2/", "mock_dir2/2/b.txt", "mock_dir2/3/", "mock_dir2/3/b.txt", "mock_dir2/3/2/", "mock_dir2/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Different levels of parent paths | Multiple paths in 'fileList' | selected - 2 directories - 1 | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/1")
		path2 := getTestMocksAsset("mock_dir2/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"mock_dir1/", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir2/", "mock_dir2/a.txt", "mock_dir2/1/", "mock_dir2/1/a.txt", "mock_dir2/2/", "mock_dir2/2/b.txt", "mock_dir2/3/", "mock_dir2/3/b.txt", "mock_dir2/3/2/", "mock_dir2/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Different levels of parent paths | Multiple paths in 'fileList' | selected - 2 directories - 2 | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/1")
		path2 := getTestMocksAsset("mock_dir3/dir_1/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"mock_dir1/", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir3/", "mock_dir3/dir_1/", "mock_dir3/dir_1/a.txt", "mock_dir3/dir_1/1/", "mock_dir3/dir_1/1/a.txt", "mock_dir3/dir_1/2/", "mock_dir3/dir_1/2/b.txt", "mock_dir3/dir_1/3/", "mock_dir3/dir_1/3/b.txt", "mock_dir3/dir_1/3/2/", "mock_dir3/dir_1/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Different levels of parent paths | Multiple paths in 'fileList' | selected - 2 files and 2 directories | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/1")
		path2 := getTestMocksAsset("mock_dir2/3/2/b.txt")
		path3 := getTestMocksAsset("mock_dir3/dir_1/1/a.txt")
		path4 := getTestMocksAsset("mock_dir3/dir_1/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2, path3, path4},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"mock_dir1/", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir2/", "mock_dir2/3/", "mock_dir2/3/2/", "mock_dir2/3/2/b.txt", "mock_dir3/", "mock_dir3/dir_1/", "mock_dir3/dir_1/a.txt", "mock_dir3/dir_1/1/", "mock_dir3/dir_1/1/a.txt", "mock_dir3/dir_1/2/", "mock_dir3/dir_1/2/b.txt", "mock_dir3/dir_1/3/", "mock_dir3/dir_1/3/b.txt", "mock_dir3/dir_1/3/2/", "mock_dir3/dir_1/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - same 2 files and 2 directories | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir1/1")
		path2 := getTestMocksAsset("mock_dir1/1")
		path3 := getTestMocksAsset("mock_dir2/3/2/b.txt")
		path4 := getTestMocksAsset("mock_dir2/3/2/b.txt")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2, path3, path4},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"mock_dir1/", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir2/", "mock_dir2/3/", "mock_dir2/3/2/", "mock_dir2/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - 1 file and 1 directory from the same nested parent | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir2/3/")
		path2 := getTestMocksAsset("mock_dir2/3/2/b.txt")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"b.txt", "2/", "2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - 1 file and 1 directory from the same nested parent - 2 | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir2/3/2/b.txt")
		path2 := getTestMocksAsset("mock_dir2/3/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"b.txt", "2/", "2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - same file multiple times | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir3/b.txt")
		path2 := getTestMocksAsset("mock_dir3/b.txt")
		path3 := getTestMocksAsset("mock_dir3/b.txt")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2, path3},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - same directory multiple times | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir3/")
		path2 := getTestMocksAsset("mock_dir3/")
		path3 := getTestMocksAsset("mock_dir3/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1, path2, path3},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionList := []string{"a.txt", "b.txt", "1/", "1/a.txt", "2/", "2/b.txt", "dir_1/", "dir_1/a.txt", "dir_1/1/", "dir_1/1/a.txt", "dir_1/2/", "dir_1/2/b.txt", "dir_1/3/", "dir_1/3/b.txt", "dir_1/3/2/", "dir_1/3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionList)
		})
	})

	Convey("Multiple paths in 'fileList' | selected - no file | It should not throw an error", func() {
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionArr := []string(nil)

			_testListingPackedArchive(_metaObj, password, assertionArr)
		})
	})

	Convey("symlink | directory | It should not throw an error", func() {
		path1 := getTestMocksAsset("mock_dir4/")
		_packObj := &ArchivePack{
			password:          password,
			fileList:          []string{path1},
			encryptionMethod:  encryptionMethod,
			overwriteExisting: true,
		}

		err := startPacking(_metaObj, _packObj)

		So(err, ShouldBeNil)

		Convey("List Packed Archive files", func() {
			assertionArr := []string{"a.txt", "1/", "1/a.txt", "2/", "2/b.txt", "3/", "3/b.txt", "3/2/", "3/2/b.txt"}

			_testListingPackedArchive(_metaObj, password, assertionArr)
		})
	})
}

func TestPacking(t *testing.T) {
	//Convey("Packing | No encryption - ZIP", t, func() {
	//	filename := newTempMocksAsset("arc_test_pack.zip")
	//
	//	_metaObj := &ArchiveMeta{filename: filename}
	//
	//	_testPacking(_metaObj, "", zip.StandardEncryption)
	//})
	//
	//Convey("Packing | Encrypted - ZIP (StandardEncryption)", t, func() {
	//	filename := newTempMocksAsset("arc_test_stdenc_pack.zip")
	//
	//	_metaObj := &ArchiveMeta{filename: filename}
	//
	//	_testPacking(_metaObj, "1234567", zip.StandardEncryption)
	//})
	//
	//Convey("Packing | Tar", t, func() {
	//	filename := newTempMocksAsset("arc_test_stdenc_pack.tar")
	//
	//	_metaObj := &ArchiveMeta{filename: filename}
	//
	//	_testPacking(_metaObj, "", 0)
	//})
	//
	//Convey("Packing | Tar.gz", t, func() {
	//	filename := newTempMocksAsset("arc_test_stdenc_pack.tar.gz")
	//
	//	_metaObj := &ArchiveMeta{filename: filename}
	//
	//	_testPacking(_metaObj, "", 0)
	//})
	//Convey("Packing | Tar.bz2", t, func() {
	//	filename := newTempMocksAsset("arc_test_stdenc_pack.tar.bz2")
	//
	//	_metaObj := &ArchiveMeta{filename: filename}
	//
	//	_testPacking(_metaObj, "", 0)
	//})
	//Convey("Packing | Tar.br (brotli)", t, func() {
	//	filename := newTempMocksAsset("arc_test_stdenc_pack.tar.br")
	//
	//	_metaObj := &ArchiveMeta{filename: filename}
	//
	//	_testPacking(_metaObj, "", 0)
	//})
	Convey("Packing | Tar.lz4", t, func() {
		filename := newTempMocksAsset("arc_test_stdenc_pack.tar.lz4")

		_metaObj := &ArchiveMeta{filename: filename}

		_testPacking(_metaObj, "", 0)
	})
}
