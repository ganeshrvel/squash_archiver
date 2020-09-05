package main

import (
	"fmt"
	ignore "github.com/sabhiram/go-gitignore"
	"github.com/yeka/zip"
	"io"
	"os"
	"path/filepath"
	"strings"
)

func startUnpackingZip(arc ZipArchive) error {
	_filename := arc.meta.filename
	_password := arc.meta.password
	_destination := arc.unpack.destination
	_gitIgnorePattern := arc.meta.gitIgnorePattern
	_fileList := arc.unpack.fileList

	allowFileFiltering := len(_fileList) > 0

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

		if allowFileFiltering {
			matched := StringFilter(_fileList, func(s string) bool {
				_fName := fixDirSlash(file.FileInfo().IsDir(), file.Name)
				return strings.HasPrefix(_fName, s) // return foo_testfor
			})

			if len(matched) < 1 {
				continue
			}
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

	count := 0
	for absolutePath, file := range zipFilePathListMap {
		count += 1
		pInfo.packingProgress(ch, totalFiles, absolutePath, count)

		if err := addFileToDisk(&file.zipFileInfo, absolutePath); err != nil {
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
