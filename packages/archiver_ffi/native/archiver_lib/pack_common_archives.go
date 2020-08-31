package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	"github.com/kr/pretty"
	"os"
)

func packCommonArchives(arc *CommonArchive, newArchiveFile *archiver.TarGz, fileList []string, commonParentPath string) error {
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
		pretty.Println("\nitem", item.absFilepath)

		if err := addFileToCommonArchive(newArchiveFile, item.fileInfo, item.absFilepath, item.relativeFilePath); err != nil {
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

func addFileToCommonArchive(newArchiveFile *archiver.TarGz, fileInfo os.FileInfo, filename string, relativeFilename string) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	return newArchiveFile.Write(archiver.File{
		FileInfo: archiver.FileInfo{
			FileInfo:   fileInfo,
			CustomName: relativeFilename,
		},
		OriginalPath: filename,
		ReadCloser:   fileToZip,
	})
}
