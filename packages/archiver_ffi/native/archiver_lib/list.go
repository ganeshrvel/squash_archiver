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
	"strings"
)

// list zip archives
// yeka package is used here to list encrypted zip files
func (arc zipArchive) list() ([]archiveFileinfo, error) {
	_filename := arc.filename
	_searchPath := arc.searchPath
	_password := arc.password

	reader, err := zip.OpenReader(_filename)
	if err != nil {
		return nil, err
	}

	defer func() {
		if err = reader.Close(); err != nil {
			fmt.Printf("%s\n", err)
		}
	}()

	var filteredPaths []archiveFileinfo

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
			fmt.Printf("%s\n", err)
		}

		fileInfo := archiveFileinfo{
			Mode:     file.FileInfo().Mode(),
			Size:     file.FileInfo().Size(),
			IsDir:    file.FileInfo().IsDir(),
			ModTime:  file.FileInfo().ModTime(),
			Name:     file.FileInfo().Name(),
			FullPath: file.Name,
		}

		allowIncludeFile := getFilteredFiles(fileInfo, _searchPath)

		if allowIncludeFile {
			filteredPaths = append(filteredPaths, fileInfo)
		}
	}

	return filteredPaths, err
}

// every other supported archives
func (arc commonArchive) list() ([]archiveFileinfo, error) {
	_filename := arc.filename
	_password := arc.password
	_searchPath := arc.searchPath

	arcFileObj, err := archiver.ByExtension(_filename)

	if err != nil {
		return nil, err
	}

	err = getArchiveFormat(&arcFileObj, _password)

	if err != nil {
		return nil, err
	}

	var w, ok = arcFileObj.(archiver.Walker)
	if !ok {
		return nil, fmt.Errorf("some error occured while reading the archive")
	}

	var filteredPaths []archiveFileinfo

	err = w.Walk(_filename, func(file archiver.File) error {
		var fileInfo archiveFileinfo

		switch fileHeader := file.Header.(type) {
		case *tar.Header:
			fileInfo = archiveFileinfo{
				Mode:     file.Mode(),
				Size:     file.Size(),
				IsDir:    file.IsDir(),
				ModTime:  file.ModTime(),
				Name:     file.Name(),
				FullPath: fileHeader.Name,
			}

			break

		case *rardecode.FileHeader:
			fileInfo = archiveFileinfo{
				Mode:     file.Mode(),
				Size:     file.Size(),
				IsDir:    file.IsDir(),
				ModTime:  file.ModTime(),
				Name:     file.Name(),
				FullPath: fileHeader.Name,
			}

			break

		default:
			fileInfo = archiveFileinfo{
				Mode:     file.Mode(),
				Size:     file.Size(),
				IsDir:    file.IsDir(),
				ModTime:  file.ModTime(),
				Name:     file.Name(),
				FullPath: file.FileInfo.Name(),
			}

			break
		}

		allowIncludeFile := getFilteredFiles(fileInfo, _searchPath)

		if allowIncludeFile {
			filteredPaths = append(filteredPaths, fileInfo)
		}

		return nil
	})

	return filteredPaths, err
}

func getArchiveFormat(arcFileObj *interface{}, password string) error {
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

func getFilteredFiles(fileInfo archiveFileinfo, searchPath string) (ok bool) {
	if funk.Contains(FileDenylist, fileInfo.Name) {
		return false
	}

	if searchPath != "" && searchPath != "/" {
		if searchPath == fileInfo.FullPath {
			return false
		}

		filteredPath := strings.HasPrefix(fileInfo.FullPath, searchPath)

		if filteredPath {
			return true
		}

		return false
	}

	return true
}

func getArchiveFileList(filename string, password string, searchPath string) {
	var arcObj archiveManager

	ext := filepath.Ext(filename)

	_baseArcObj := listArchive{filename: filename, password: password, searchPath: searchPath, recursive: true}

	switch ext {
	case ".zip":
		arcObj = zipArchive{_baseArcObj}

		break

	default:
		arcObj = commonArchive{_baseArcObj}

		break
	}

	result, err := arcObj.list()

	if err != nil {
		fmt.Println(err)

		return
	}

	fmt.Println(result)
}
