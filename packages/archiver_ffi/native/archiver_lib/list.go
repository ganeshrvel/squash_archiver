package main

// TODO proper error handling. Return error back to the callee

import (
	"archive/tar"
	"fmt"
	"github.com/mholt/archiver"
	"github.com/nwaples/rardecode"
	"github.com/thoas/go-funk"
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
		sort.Slice(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].FullPath > list[j].FullPath
			}

			return list[i].FullPath < list[j].FullPath
		})
		break
	case OrderByName:
		sort.Slice(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].Name > list[j].Name
			}

			return list[i].Name < list[j].Name
		})
		break
	case OrderByModTime:
		sort.Slice(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].ModTime.After(list[j].ModTime)
			}

			return list[i].ModTime.Before(list[j].ModTime)
		})
		break
	case OrderBySize:
		sort.Slice(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].Size > list[j].Size
			}

			return list[i].Size < list[j].Size
		})
		break
	}

	return list
}

func getFilteredFiles(fileInfo ArchiveFileInfo, listDirectoryPath string, recursive bool) (include bool) {
	if funk.Contains(FileDenylist, fileInfo.Name) {
		return false
	}

	isInPath := strings.HasPrefix(fileInfo.FullPath, listDirectoryPath)

	if isInPath {
		// if recursive mode is true return all files and subdirectories under the filtered path
		if recursive == true {
			return true
		}

		// dont return the directory path if it's listDirectoryPath. This will make sure that only files and sub directories are returned
		if listDirectoryPath == fileInfo.FullPath {
			return false
		}

		slashSplitListDirectoryPath := strings.Split(listDirectoryPath, "/")
		slashSplitListDirectoryPathLength := len(slashSplitListDirectoryPath)

		slashSplitFullPath := strings.Split(fileInfo.FullPath, "/")
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

func archiveFormat(arcFileObj *interface{}, password string) error {
	const (
		overwriteExisting      = false
		mkdirAll               = false
		implicitTopLevelFolder = false
		continueOnError        = true
		compressionLevel       = 0
		selectiveCompression   = false
	)

	mytar := &archiver.Tar{
		OverwriteExisting:      overwriteExisting,
		MkdirAll:               mkdirAll,
		ImplicitTopLevelFolder: implicitTopLevelFolder,
		ContinueOnError:        continueOnError,
	}

	_arcFileObj := *arcFileObj

	// refer https://github.com/mholt/archiver/blob/master/cmd/arc/main.go for more
	switch arcValues := _arcFileObj.(type) {
	case *archiver.Rar:
		arcValues.OverwriteExisting = overwriteExisting
		arcValues.MkdirAll = mkdirAll
		arcValues.ImplicitTopLevelFolder = implicitTopLevelFolder
		arcValues.ContinueOnError = continueOnError
		arcValues.Password = password

		break

	case *archiver.Tar:
		arcValues = mytar

		break

	case *archiver.TarBrotli:
		arcValues.Tar = mytar
		arcValues.Quality = compressionLevel

		break

	case *archiver.TarBz2:
	case *archiver.TarGz:
	case *archiver.TarLz4:
		arcValues.Tar = mytar
		arcValues.CompressionLevel = compressionLevel

		break

	case *archiver.TarSz:
	case *archiver.TarXz:
	case *archiver.TarZstd:
		arcValues.Tar = mytar

		break

	case *archiver.Zip:
		arcValues.CompressionLevel = compressionLevel
		arcValues.OverwriteExisting = overwriteExisting
		arcValues.MkdirAll = mkdirAll
		arcValues.SelectiveCompression = selectiveCompression
		arcValues.ImplicitTopLevelFolder = implicitTopLevelFolder
		arcValues.ContinueOnError = continueOnError

		break

	case *archiver.Brotli:
		arcValues.Quality = compressionLevel

		break

	case *archiver.Bz2:
	case *archiver.Lz4:
	case *archiver.Gz:
		arcValues.CompressionLevel = compressionLevel

		break
	case *archiver.Snappy:
	case *archiver.Xz:
	case *archiver.Zstd:
		break

	default:
		return fmt.Errorf("format does not support customization")
	}

	return nil
}

// list zip archives
// yeka package is used here to list encrypted zip files
func (arc ZipArchive) list() ([]ArchiveFileInfo, error) {
	_filename := arc.filename
	_listDirectoryPath := arc.listDirectoryPath
	_password := arc.password
	_recursive := arc.recursive
	_orderBy := arc.orderBy
	_orderDir := arc.orderDir

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

		allowIncludeFile := getFilteredFiles(fileInfo, _listDirectoryPath, _recursive)

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

// List common archives
func (arc CommonArchive) list() ([]ArchiveFileInfo, error) {
	_filename := arc.filename
	_password := arc.password
	_listDirectoryPath := arc.listDirectoryPath
	_recursive := arc.recursive
	_orderBy := arc.orderBy
	_orderDir := arc.orderDir

	arcFileObj, err := archiver.ByExtension(_filename)

	if err != nil {
		return nil, err
	}

	err = archiveFormat(&arcFileObj, _password)

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

		allowIncludeFile := getFilteredFiles(fileInfo, _listDirectoryPath, _recursive)

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

	if arc.orderDir == OrderDirNone {
		return filteredPaths, err
	}

	sortedPaths := sortFiles(filteredPaths, _orderBy, _orderDir)

	return sortedPaths, err
}

func getArchiveFileList(meta *ArchiveMeta, list *ArchiveList) ([]ArchiveFileInfo, error) {
	_meta := *meta
	_list := *list

	var arcObj ArchiveLister

	ext := filepath.Ext(meta.filename)

	// add a trailing slash to [listDirectoryPath] if missing
	if _list.listDirectoryPath != "" && !strings.HasSuffix(_list.listDirectoryPath, "/") {
		_list.listDirectoryPath = fmt.Sprintf("%s/", _list.listDirectoryPath)
	}

	switch ext {
	case ".zip":
		arcObj = ZipArchive{_meta, _list}

		break

	default:
		arcObj = CommonArchive{_meta, _list}

		break
	}

	return arcObj.list()
}
