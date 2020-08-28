package main

import (
	"fmt"
	"github.com/kr/pretty"
	"github.com/yeka/zip"
	"path/filepath"
	"strings"
)

//export ListArchive
func ListArchive() {
	filename := getDesktopFiles("test.zip")

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist: %s\n", filename)

		return
	}

	_metaObj := &ArchiveMeta{filename: filename}

	_listObj := &ArchiveRead{
		password:          "",
		listDirectoryPath: "phayes-geoPHP-6855624/",
		recursive:         true,
		orderBy:           OrderByName,
		orderDir:          OrderDirAsc,
	}

	result, err := getArchiveFileList(_metaObj, _listObj)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", result)

}

//export IsArchiveEncrypted
func IsArchiveEncrypted() {
	filename := getDesktopFiles("test.enc.zip")

	if exist := fileExists(filename); !exist {
		fmt.Printf("file does not exist %s\n", filename)

		return
	}

	_metaObj := &ArchiveMeta{filename: filename}

	result, err := isArchiveEncrypted(_metaObj)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", result)

}

//export Pack
func Pack() {
	filename := getDesktopFiles("12345.pack.zip")
	path1 := getDesktopFiles("test")
	path2 := getDesktopFiles("openmtp/dll")

	_metaObj := &ArchiveMeta{filename: filename}

	_packObj := &ArchivePack{
		password:          "",
		fileList:          []string{path1, path2},
		gitIgnorePattern:  "",
		encryptionMethod:  zip.StandardEncryption,
		overwriteExisting: true,
	}

	err := startPacking(_metaObj, _packObj)

	if err != nil {
		fmt.Printf("Error occured: %+v\n", err)

		return
	}

	fmt.Printf("Result: %+v\n", "Success")
}

// Unused
func main() {
	//ListArchive()
	//IsArchiveEncrypted()
	//Pack()

	var splittedList []ArchiveFileInfo
	/*	for _, x := range list {
		splittedList_ = append(splittedList_, x.FullPath)
	}*/

	//__splittedList := []string{"mock_dir1/1/", "mock_dir1/3/", "mock_dir1/2/", "mock_dir1/a.txt"}

	//__splittedList := []string{"/mock_dir1/3/2", "/mock_dir1/3/2/b.txt", "mock_dir1/3/b.txt"}
	/*__splittedList := []string{"mock_dir1/3/2", "mock_dir1/3/2/b", "mock_dir1/2/", "mock_dir1/1", "mock_dir1/3/b.txt"}*/
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

	/*	for _, x := range __splittedList {

		isDir := !strings.HasSuffix(x, ".txt")
		var pathSplitted [2]string

		if !isDir {
			pathSplitted = [2]string{filepath.Dir(x), filepath.Base(x)}
		} else {
			pathSplitted = [2]string{x, ""}
		}

		splittedList = append(splittedList, filePathListSortInfo{
			pathSplitted: pathSplitted,
			isDir:        isDir,
		})
	}*/

	for _, x := range list {
		isDir := !strings.HasSuffix(x, ".txt")

		var pathSplitted [2]string

		if !isDir {
			pathSplitted = [2]string{filepath.Dir(x), filepath.Base(x)}
		} else {
			pathSplitted = [2]string{filepath.Dir(x), ""}
		}

		splittedList = append(splittedList, ArchiveFileInfo{
			IsDir:        isDir,
			FullPath:     x,
			splittedPath: pathSplitted,
		})
	}

	_sortPath(&splittedList, OrderDirAsc, 0, 0, len(splittedList)-1)

	var sortedPath []string

	for _, x := range splittedList {
		sortedPath = append(sortedPath, x.FullPath)
	}

	pretty.Println(sortedPath)
}
