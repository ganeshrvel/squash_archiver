package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	"os"
	"strings"
)

func packCommonArchives(arc *CommonArchive, arcFileObj interface{}, fileList *[]string, commonParentPath string) error {
	var newArchiveFile interface{ archiver.Writer }
	var err error

	switch value := arcFileObj.(type) {
	case *archiver.Tar:
		newArchiveFile = value
		break

	case *archiver.TarGz:
		newArchiveFile = value
		break

	case *archiver.TarBz2:
		newArchiveFile = value
		break

	case *archiver.TarBrotli:
		newArchiveFile = value
		break

	case *archiver.TarLz4:
		newArchiveFile = value
		break

	case *archiver.TarSz:
		newArchiveFile = value
		break

	case *archiver.TarXz:
		newArchiveFile = value
		break

	case *archiver.TarZstd:
		newArchiveFile = value
		break

	default:
		return fmt.Errorf("archive file format is not supported")
	}

	_filename := arc.meta.filename
	_gitIgnorePattern := arc.pack.gitIgnorePattern

	out, err := os.Create(_filename)
	if err != nil {
		return err
	}

	err = newArchiveFile.Create(out)
	if err != nil {
		return err
	}

	zipFilePathListMap := make(map[string]createZipFilePathList)

	err = processFilesForPacking(&zipFilePathListMap, fileList, commonParentPath, &_gitIgnorePattern)
	if err != nil {
		return err
	}

	totalFiles := len(zipFilePathListMap)
	pInfo, ch := initPackingProgress(totalFiles)

	for absolutePath, item := range zipFilePathListMap {
		pInfo.packingProgress(ch, totalFiles, absolutePath)

		if err := addFileToCommonArchives(&newArchiveFile, item.fileInfo, item.absFilepath, item.relativeFilePath, item.isDir)
			err != nil {
			return err
		}
	}

	pInfo.closePacking(ch, totalFiles)

	defer func() {
		if err := newArchiveFile.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	return err
}

func addFileToCommonArchives(newArchiveFile *interface{ archiver.Writer }, fileInfo os.FileInfo, filename string, relativeFilename string, isDir bool) error {
	_newArchiveFile := *newArchiveFile

	fileToZip, err := os.Open(filename)
	_relativeFilename := relativeFilename

	if isDir {
		_relativeFilename = strings.TrimRight(_relativeFilename, PathSep)
	}

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	err = _newArchiveFile.Write(archiver.File{
		FileInfo: archiver.FileInfo{
			FileInfo:   fileInfo,
			CustomName: _relativeFilename,
		},
		OriginalPath: filename,
		ReadCloser:   fileToZip,
	})

	return err
}
