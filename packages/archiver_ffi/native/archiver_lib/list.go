package main

// TODO proper error handling. Return error back to the callee

import (
	"archive/tar"
	"fmt"
	"github.com/ganeshrvel/archiver"
	"github.com/nwaples/rardecode"
	"github.com/sabhiram/go-gitignore"
	"github.com/yeka/zip"
	"io/ioutil"
	"path/filepath"
	"sort"
	"strings"
)

func sortFiles(list []ArchiveFileInfo, orderBy ArchiveOrderBy, orderDir ArchiveOrderDir) []ArchiveFileInfo {
	if orderDir == OrderDirNone {
		return list
	}

	switch orderBy {
	case OrderByFullPath:
		return sortPath(list, orderDir)

	case OrderByName:
		sort.SliceStable(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].Name > list[j].Name
			}

			return list[i].Name < list[j].Name
		})
		break
	case OrderByModTime:
		sort.SliceStable(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].ModTime.After(list[j].ModTime)
			}

			return list[i].ModTime.Before(list[j].ModTime)
		})
		break
	case OrderBySize:
		sort.SliceStable(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].Size > list[j].Size
			}

			return list[i].Size < list[j].Size
		})
		break
	}

	return list
}

func getFilteredFiles(fileInfo ArchiveFileInfo, listDirectoryPath string, recursive bool, gitIgnorePattern []string) (include bool) {
	var ignoreList []string
	ignoreList = append(ignoreList, GlobalPatternDenylist...)
	ignoreList = append(ignoreList, gitIgnorePattern...)

	ignoreMatches, _ := ignore.CompileIgnoreLines(ignoreList...)

	if ignoreMatches.MatchesPath(fileInfo.FullPath) {
		return false
	}

	isInPath := strings.HasPrefix(fileInfo.FullPath, listDirectoryPath)

	if isInPath {
		// dont return the directory path if it's listDirectoryPath. This will make sure that only files and sub directories are returned
		if listDirectoryPath == fileInfo.FullPath {
			return false
		}

		// if recursive mode is true return all files and subdirectories under the filtered path
		if recursive == true {
			return true
		}

		slashSplitListDirectoryPath := strings.Split(listDirectoryPath, PathSep)
		slashSplitListDirectoryPathLength := len(slashSplitListDirectoryPath)

		slashSplitFullPath := strings.Split(fileInfo.FullPath, PathSep)
		slashSplitFullPathLength := len(slashSplitFullPath)

		// if directory allow an extra '/' to figure out the subdirectory
		if fileInfo.IsDir && slashSplitFullPathLength < slashSplitListDirectoryPathLength+2 {
			return true
		}

		if !fileInfo.IsDir && slashSplitFullPathLength < slashSplitListDirectoryPathLength+1 {
			return true
		}
	}

	return false
}

func pathExists(path string, searchPath string) bool {
	return path != "" && strings.HasPrefix(searchPath, path)
}

// list files in zip archives
// yeka package is used here to list encrypted zip files
func (arc ZipArchive) list() ([]ArchiveFileInfo, error) {
	_filename := arc.meta.filename
	_listDirectoryPath := arc.read.listDirectoryPath
	_password := arc.read.password
	_recursive := arc.read.recursive
	_orderBy := arc.read.orderBy
	_orderDir := arc.read.orderDir
	_gitIgnorePattern := arc.read.gitIgnorePattern

	reader, err := zip.OpenReader(_filename)
	if err != nil {
		return nil, err
	}

	defer func() {
		if err = reader.Close(); err != nil {
			fmt.Printf("%v\n", err)
		}
	}()

	var filteredPaths []ArchiveFileInfo

	isListDirectoryPathExist := _listDirectoryPath == ""

	for _, file := range reader.File {
		if file.IsEncrypted() {
			file.SetPassword(_password)
		}

		fileReader, err := file.Open()
		if err != nil {
			return nil, err
		}

		_, err = ioutil.ReadAll(fileReader)

		if err != nil {
			return nil, err
		}

		if err = fileReader.Close(); err != nil {
			fmt.Printf("%+v\n", err)
		}

		fileInfo := ArchiveFileInfo{
			Mode:     file.FileInfo().Mode(),
			Size:     file.FileInfo().Size(),
			IsDir:    file.FileInfo().IsDir(),
			ModTime:  file.FileInfo().ModTime(),
			Name:     file.FileInfo().Name(),
			FullPath: file.Name,
		}

		sanitizeDirPath(&fileInfo)

		allowIncludeFile := getFilteredFiles(fileInfo, _listDirectoryPath, _recursive, _gitIgnorePattern)

		if allowIncludeFile {
			filteredPaths = append(filteredPaths, fileInfo)
		}

		if !isListDirectoryPathExist && pathExists(_listDirectoryPath, fileInfo.FullPath) {
			isListDirectoryPathExist = true
		}
	}

	if !isListDirectoryPathExist {
		return filteredPaths, fmt.Errorf("path not found to filter: %s", _listDirectoryPath)
	}

	sortedPaths := sortFiles(filteredPaths, _orderBy, _orderDir)

	return sortedPaths, err
}

// List files in the common archives
func (arc CommonArchive) list() ([]ArchiveFileInfo, error) {
	_filename := arc.meta.filename
	_password := arc.read.password
	_listDirectoryPath := arc.read.listDirectoryPath
	_recursive := arc.read.recursive
	_orderBy := arc.read.orderBy
	_orderDir := arc.read.orderDir
	_gitIgnorePattern := arc.read.gitIgnorePattern
	_overwriteExisting := arc.pack.overwriteExisting

	arcFileObj, err := archiver.ByExtension(_filename)

	if err != nil {
		return nil, err
	}

	err = archiveFormat(&arcFileObj, _password, _overwriteExisting)

	if err != nil {
		return nil, err
	}

	var w, ok = arcFileObj.(archiver.Walker)
	if !ok {
		return nil, fmt.Errorf("some error occured while reading the archive")
	}

	var filteredPaths []ArchiveFileInfo

	isListDirectoryPathExist := _listDirectoryPath == ""

	err = w.Walk(_filename, func(file archiver.File) error {
		var fileInfo ArchiveFileInfo

		switch fileHeader := file.Header.(type) {
		case *tar.Header:
			fileInfo = ArchiveFileInfo{
				Mode:     file.Mode(),
				Size:     file.Size(),
				IsDir:    file.IsDir(),
				ModTime:  file.ModTime(),
				Name:     file.Name(),
				FullPath: fileHeader.Name,
			}

			break

		case *rardecode.FileHeader:
			fileInfo = ArchiveFileInfo{
				Mode:     file.Mode(),
				Size:     file.Size(),
				IsDir:    file.IsDir(),
				ModTime:  file.ModTime(),
				Name:     file.Name(),
				FullPath: fileHeader.Name,
			}

			break

		default:
			fileInfo = ArchiveFileInfo{
				Mode:     file.Mode(),
				Size:     file.Size(),
				IsDir:    file.IsDir(),
				ModTime:  file.ModTime(),
				Name:     file.Name(),
				FullPath: file.FileInfo.Name(),
			}

			break
		}

		sanitizeDirPath(&fileInfo)

		allowIncludeFile := getFilteredFiles(fileInfo, _listDirectoryPath, _recursive, _gitIgnorePattern)

		if allowIncludeFile {
			filteredPaths = append(filteredPaths, fileInfo)
		}

		if !isListDirectoryPathExist && pathExists(_listDirectoryPath, fileInfo.FullPath) {
			isListDirectoryPathExist = true
		}

		return nil
	})

	if !isListDirectoryPathExist {
		return filteredPaths, fmt.Errorf("path not found to filter: %s", _listDirectoryPath)
	}

	if arc.read.orderDir == OrderDirNone {
		return filteredPaths, err
	}

	sortedPaths := sortFiles(filteredPaths, _orderBy, _orderDir)

	return sortedPaths, err
}

func getArchiveFileList(meta *ArchiveMeta, read *ArchiveRead) ([]ArchiveFileInfo, error) {
	_meta := *meta
	_read := *read

	var arcObj ArchiveReader

	ext := filepath.Ext(meta.filename)

	// add a trailing slash to [listDirectoryPath] if missing
	if _read.listDirectoryPath != "" && !strings.HasSuffix(_read.listDirectoryPath, PathSep) {
		_read.listDirectoryPath = fmt.Sprintf("%s%s", _read.listDirectoryPath, PathSep)
	}

	switch ext {
	case ".zip":
		arcObj = ZipArchive{meta: _meta, read: _read}

		break

	default:
		arcObj = CommonArchive{meta: _meta, read: _read}

		break
	}

	return arcObj.list()
}

func sanitizeDirPath(fileInfo *ArchiveFileInfo, ) {
	// add a directory separator if missing in the path.
	// we use directory separator to perform some calculations
	if fileInfo.IsDir && !strings.HasSuffix(fileInfo.FullPath, PathSep) {
		fileInfo.FullPath = fmt.Sprintf("%s%s", fileInfo.FullPath, PathSep)
	}
}
