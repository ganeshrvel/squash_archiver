package main

import (
	. "github.com/smartystreets/goconvey/convey"
	"github.com/yeka/zip"
	"path/filepath"
	"strings"
	"testing"
)

func _testArchiveListing(_metaObj *ArchiveMeta) {
	Convey("General tests", func() {
		Convey("Incorrect listDirectoryPath - it should throw an error", func() {
			_listObj := &ArchiveRead{
				listDirectoryPath: "qwerty/",
				recursive:         true,
				orderBy:           OrderByName,
				orderDir:          OrderDirAsc,
			}

			_, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeError)
		})
	})

	Convey("OrderByName", func() {
		Convey("Asc | recursive=false - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				listDirectoryPath: "mock_dir1/",
				recursive:         false,
				orderBy:           OrderByName,
				orderDir:          OrderDirAsc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/1/", "mock_dir1/2/", "mock_dir1/3/", "mock_dir1/a.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("Desc | recursive=false | 1 - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				listDirectoryPath: "mock_dir1/3/",
				recursive:         false,
				orderBy:           OrderByName,
				orderDir:          OrderDirDesc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/3/b.txt", "mock_dir1/3/2/"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("Desc | recursive=false | 2 - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				listDirectoryPath: "mock_dir1/3",
				recursive:         false,
				orderBy:           OrderByName,
				orderDir:          OrderDirDesc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/3/b.txt", "mock_dir1/3/2/"}

			So(itemsArr, ShouldResemble, assertionArr)
		})
	})

	Convey("gitIgnore", func() {
		Convey("gitIgnore | recursive=true | Asc | 1 - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				listDirectoryPath: "",
				recursive:         true,
				orderBy:           OrderByFullPath,
				orderDir:          OrderDirAsc,
			}

			_metaObj.gitIgnorePattern = []string{"a.txt"}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/", "mock_dir1/1/", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("gitIgnore | recursive=true | Asc | 2  - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				listDirectoryPath: "mock_dir1/",
				recursive:         true,
				orderBy:           OrderByFullPath,
				orderDir:          OrderDirAsc,
			}

			_metaObj.gitIgnorePattern = []string{"a.txt"}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/1/", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})
	})

	Convey("empty listDirectoryPath", func() {
		Convey("recursive=true | Asc - it should not throw an error", func() {
			_listObj := &ArchiveRead{
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

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("recursive=false | Desc - it should not throw an error", func() {
			_listObj := &ArchiveRead{
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

	Convey("OrderByFullPath", func() {
		Convey("Asc | recursive=true | 1 - it should not throw an error", func() {
			_listObj := &ArchiveRead{
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

		Convey("Asc | recursive=true | 2 - it should not throw an error", func() {

			_listObj := &ArchiveRead{
				listDirectoryPath: "mock_dir1/3",
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

			assertionArr := []string{"mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("Asc | recursive=false | 3 - it should not throw an error", func() {

			_listObj := &ArchiveRead{
				listDirectoryPath: "mock_dir1/3",
				recursive:         false,
				orderBy:           OrderByFullPath,
				orderDir:          OrderDirAsc,
			}

			result, err := getArchiveFileList(_metaObj, _listObj)

			So(err, ShouldBeNil)

			var itemsArr []string

			for _, item := range result {
				itemsArr = append(itemsArr, item.FullPath)
			}

			assertionArr := []string{"mock_dir1/3/b.txt", "mock_dir1/3/2/"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("Desc | recursive=true | 1 - it should not throw an error", func() {
			_listObj := &ArchiveRead{
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

			assertionArr := []string{"mock_dir1/3/2/b.txt", "mock_dir1/3/2/", "mock_dir1/3/b.txt", "mock_dir1/3/", "mock_dir1/2/b.txt", "mock_dir1/2/", "mock_dir1/1/a.txt", "mock_dir1/1/", "mock_dir1/a.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

		Convey("Desc | recursive=false | 2 - it should not throw an error", func() {
			_listObj := &ArchiveRead{
				listDirectoryPath: "mock_dir1/",
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

			assertionArr := []string{"mock_dir1/3/", "mock_dir1/2/", "mock_dir1/1/", "mock_dir1/a.txt"}

			So(itemsArr, ShouldResemble, assertionArr)
		})

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
				"A/B/file2.txt", "A/file5.txt"}

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

			assertionArr := []string{"A/file1.txt", "A/file2.txt", "A/file3.txt", "A/file5.txt", "A/B/", "A/B/123.txt", "A/B/file1.txt", "A/B/file2.txt", "A/B/file2.txt", "A/B/C/file1.txt", "A/B/C/D/file1.txt", "A/B/C/D/file3.txt", "A/W/file1.txt", "A/W/X/file1.txt", "A/W/X/Y/file1.txt", "A/W/X/Y/Z/file1.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/1/2/", "mock_dir1/2/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b/"}

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

		Convey("Asc | 3 - it should not throw an error", func() {
			var filePathList []filePathListSortInfo

			list := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

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

			assertionArr := []string{"mock_dir1/", "mock_dir1/a.txt", "mock_dir1/1/", "mock_dir1/1/a.txt", "mock_dir1/2/", "mock_dir1/2/b.txt", "mock_dir1/3/", "mock_dir1/3/b.txt", "mock_dir1/3/2/", "mock_dir1/3/2/b.txt"}

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

func _testArchiveEncryption() {
	Convey("Encrypted zip | it should return true", func() {
		filename := getTestMocksAsset("mock_enc_test_file1.zip")
		_metaObj := &ArchiveMeta{filename: filename}

		result, err := isArchiveEncrypted(_metaObj)

		So(err, ShouldBeNil)

		So(result, ShouldBeTrue)
	})

	Convey("Non Encrypted zip | it should return false", func() {
		filename := getTestMocksAsset("mock_test_file1.zip")
		_metaObj := &ArchiveMeta{filename: filename}

		result, err := isArchiveEncrypted(_metaObj)

		So(err, ShouldBeNil)

		So(result, ShouldBeFalse)
	})
}

func TestArchiveListing(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping 'TestArchiveListing' testing in short mode")
	}

	Convey("Testing OrderByFullPath", t, func() {
		_testOrderByFullPathListing()
	})

	Convey("macOS Compressed Archive Listing - ZIP", t, func() {
		filename := getTestMocksAsset("mock_mac_test_file1.zip")
		_metaObj := &ArchiveMeta{filename: filename, password: ""}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing - ZIP", t, func() {
		filename := getTestMocksAsset("mock_test_file1.zip")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing - Encrypted ZIP", t, func() {
		filename := getTestMocksAsset("mock_enc_test_file1.zip")
		_metaObj := &ArchiveMeta{filename: filename, password: "1234567", encryptionMethod: zip.StandardEncryption}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing - tar.gz", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.gz")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | 2 - tar.gz", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.gz")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | Tar.br", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.br")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | Tar.bz2", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.bz2")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | Tar.lz4", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.lz4")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | Tar.sz", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.sz")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | Tar.xz", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.xz")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | Tar.zst", t, func() {
		filename := getTestMocksAsset("mock_test_file1.tar.zst")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})

	Convey("Archive Listing | Rar", t, func() {
		filename := getTestMocksAsset("mock_test_file1.rar")
		_metaObj := &ArchiveMeta{filename: filename}

		_testArchiveListing(_metaObj)
	})
}

func TestArchiveEncryption(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping 'TestArchiveEncryption' testing in short mode")
	}

	Convey("Archive Encryption", t, func() {
		_testArchiveEncryption()
	})
}
