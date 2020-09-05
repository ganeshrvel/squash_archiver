package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	"os"
	"strings"
)

func packTarballs(arc *CommonArchive, arcFileObj interface{ archiver.Writer }, fileList *[]string, commonParentPath string) error {
	_filename := arc.meta.filename
	_gitIgnorePattern := arc.meta.gitIgnorePattern

	out, err := os.Create(_filename)
	if err != nil {
		return err
	}

	err = arcFileObj.Create(out)
	if err != nil {
		return err
	}

	zipFilePathListMap := make(map[string]createArchiveFileInfo)

	err = processFilesForPacking(&zipFilePathListMap, fileList, commonParentPath, &_gitIgnorePattern)
	if err != nil {
		return err
	}

	totalFiles := len(zipFilePathListMap)
	pInfo, ch := initPackingProgress(totalFiles)

	count := 0
	for absolutePath, item := range zipFilePathListMap {
		count += 1
		pInfo.packingProgress(ch, totalFiles, absolutePath, count)

		if err := addFileToTarBall(&arcFileObj, item.fileInfo, item.absFilepath, item.relativeFilePath, item.isDir)
			err != nil {
			return err
		}
	}

	pInfo.closePacking(ch, totalFiles)

	defer func() {
		if err := arcFileObj.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	return err
}

func addFileToTarBall(arcFileObj *interface{ archiver.Writer }, fileInfo os.FileInfo, filename string, relativeFilename string, isDir bool) error {
	_arcFileObj := *arcFileObj

	_relativeFilename := relativeFilename

	if isDir {
		_relativeFilename = strings.TrimRight(_relativeFilename, PathSep)
	}

	fileToArchive, err := os.Open(filename)
	if err != nil {
		return err
	}

	defer fileToArchive.Close()

	err = _arcFileObj.Write(archiver.File{
		FileInfo: archiver.FileInfo{
			FileInfo:   fileInfo,
			CustomName: _relativeFilename,
		},
		OriginalPath: filename,
		ReadCloser:   fileToArchive,
	})

	return err
}
