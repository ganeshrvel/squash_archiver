package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	"os"
	"strings"
)

func packTarBz2(arc *CommonArchive, newArchiveFile *archiver.TarBz2, fileList []string, commonParentPath string) error {
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

	err = processFilesForPacking(&zipFilePathListMap, &fileList, commonParentPath, &_gitIgnorePattern)
	if err != nil {
		return err
	}

	for _, item := range zipFilePathListMap {
		if err := addFileToTarBz2Archive(newArchiveFile, item.fileInfo, item.absFilepath, item.relativeFilePath, item.isDir)
			err != nil {
			return err
		}
	}

	defer func() {
		if err := newArchiveFile.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	return err
}

func addFileToTarBz2Archive(newArchiveFile *archiver.TarBz2, fileInfo os.FileInfo, filename string, relativeFilename string, isDir bool) error {
	fileToZip, err := os.Open(filename)
	_relativeFilename := relativeFilename

	if isDir {
		_relativeFilename = strings.TrimRight(_relativeFilename, PathSep)
	}

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	err = newArchiveFile.Write(archiver.File{
		FileInfo: archiver.FileInfo{
			FileInfo:   fileInfo,
			CustomName: _relativeFilename,
		},
		OriginalPath: filename,
		ReadCloser:   fileToZip,
	})

	return err
}