package main

import (
	"fmt"
	ignore "github.com/sabhiram/go-gitignore"
	"github.com/yeka/zip"
	"io"
	"os"
	"path/filepath"
)

func startUnpackingZip(arc ZipArchive) error {
	_filename := arc.meta.filename
	_password := arc.pack.password
	_destination := arc.unpack.destination
	_gitIgnorePattern := arc.unpack.gitIgnorePattern

	reader, err := zip.OpenReader(_filename)
	if err != nil {
		return err
	}

	var ignoreList []string
	ignoreList = append(ignoreList, GlobalPatternDenylist...)
	ignoreList = append(ignoreList, _gitIgnorePattern...)

	ignoreMatches, _ := ignore.CompileIgnoreLines(ignoreList...)

	zipFilePathListMap := make(map[string]extractArchiveFileInfo)

	for _, file := range reader.File {
		if file.IsEncrypted() {
			file.SetPassword(_password)
		}

		if ignoreMatches.MatchesPath(file.Name) {
			continue
		}

		_absPath := filepath.Join(_destination, file.Name)

		zipFilePathListMap[_absPath] = extractArchiveFileInfo{
			absFilepath: _absPath,
			name:        file.Name,
			fileInfo:    file.FileInfo(),
			zipFileInfo: *file,
		}
	}

	totalFiles := len(reader.File)
	pInfo, ch := initPackingProgress(totalFiles)

	for _, file := range zipFilePathListMap {
		pInfo.packingProgress(ch, totalFiles, file.absFilepath)
		if err := addFileToDisk(&file.zipFileInfo, file.absFilepath); err != nil {
			return err
		}
	}

	pInfo.closePacking(ch, totalFiles)

	defer func() {
		if err := reader.Close(); err != nil {
			fmt.Printf("%v\n", err)
		}
	}()

	return nil
}

func addFileToDisk(file *zip.File, filename string) error {
	fileToExtract, err := file.Open()

	if err != nil {
		return err
	}

	defer func() {
		if err := fileToExtract.Close(); err != nil {
			fmt.Printf("%v\n", err)
		}
	}()

	if file.FileInfo().IsDir() {
		if err := os.MkdirAll(filename, os.ModePerm); err != nil {
			return err
		}

		return nil
	} else {
		_basename := filepath.Dir(filename)

		if err := os.MkdirAll(_basename, os.ModePerm); err != nil {
			return err
		}
	}

	writer, err := os.Create(filename)
	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToExtract)

	return err
}