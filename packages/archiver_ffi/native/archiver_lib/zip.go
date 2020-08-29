package main

import (
	"fmt"
	ignore "github.com/sabhiram/go-gitignore"
	"github.com/wesovilabs/koazee"
	"github.com/yeka/zip"
	"io"
	"os"
	"path/filepath"
	"strings"
)

func getArchiveFilesRelativePath(absFilepath string, commonParentPath string) string {
	splittedFilepath := strings.Split(absFilepath, commonParentPath)

	_koazeeStream := koazee.StreamOf(splittedFilepath)
	lastItem := _koazeeStream.Last()

	return lastItem.String()
}

func createZipFile(arc *ZipArchive, _fileList []string, commonParentPath string) error {
	_filename := arc.meta.filename
	_password := arc.pack.password
	_gitIgnorePattern := arc.pack.gitIgnorePattern
	_encryptionMethod := arc.pack.encryptionMethod

	newZipFile, err := os.Create(_filename)
	if err != nil {
		return err
	}

	defer newZipFile.Close()

	zipWriter := zip.NewWriter(newZipFile)

	var ignoreList []string
	ignoreList = append(ignoreList, GlobalPatternDenylist...)
	ignoreList = append(ignoreList, _gitIgnorePattern...)

	ignoreMatches, _ := ignore.CompileIgnoreLines(ignoreList...)

	for _, item := range _fileList {
		err = filepath.Walk(item, func(absFilepath string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			relativeFilePath := absFilepath

			if commonParentPath != "" {
				// if there is only one filepath in [_fileList]
				if len(_fileList) < 2 && _fileList[0] == commonParentPath {
					splittedFilepath := strings.Split(_fileList[0], PathSep)

					_koazeeStream := koazee.StreamOf(splittedFilepath)
					lastItem := _koazeeStream.Last()
					lastPartOfFilename := lastItem.String()

					// then the selected folder name should be the root directory in the archive
					if isDir(_fileList[0]) {
						archiveFilesRelativePath := getArchiveFilesRelativePath(absFilepath, commonParentPath)

						relativeFilePath = fmt.Sprintf("%s%s", lastPartOfFilename, archiveFilesRelativePath)
					} else {
						// then the selected file should be in the root directory in the archive
						relativeFilePath = lastPartOfFilename
					}

				} else {
					relativeFilePath = getArchiveFilesRelativePath(absFilepath, commonParentPath)

				}
			}

			isFileADir := info.IsDir()
			if isFileADir && !strings.HasSuffix(relativeFilePath, PathSep) {
				relativeFilePath = fmt.Sprintf("%s%s", relativeFilePath, PathSep)
			}

			// ignore the files if pattern matches
			if ignoreMatches.MatchesPath(relativeFilePath) {
				return nil
			}

			if _password == "" {
				if err := addFileToRegularZip(zipWriter, absFilepath, relativeFilePath); err != nil {
					return err
				}
			} else {
				if err := addFileToEncryptedZip(zipWriter, absFilepath, _password, _encryptionMethod); err != nil {
					return err
				}
			}

			return nil
		})

	}

	defer func() {
		if err := zipWriter.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	return err
}

func addFileToRegularZip(zipWriter *zip.Writer, filename string, relativeFilename string) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	// Get the file information
	// Using FileInfoHeader() above only uses the basename of the file. If we want
	// to preserve the folder structure we can overwrite this with the full path.
	info, err := fileToZip.Stat()
	if err != nil {
		return err
	}

	header, err := zip.FileInfoHeader(info)

	if err != nil {
		return err
	}

	header.Name = relativeFilename

	// see http://golang.org/pkg/archive/zip/#pkg-constants
	header.Method = zip.Deflate

	writer, err := zipWriter.CreateHeader(header)
	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToZip)

	return err
}

func addFileToEncryptedZip(zipWriter *zip.Writer, filename string, password string,
	encryptionMethod zip.EncryptionMethod) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	// Get the file information
	// Using FileInfoHeader() above only uses the basename of the file. If we want
	// to preserve the folder structure we can overwrite this with the full path.

	writer, err := zipWriter.Encrypt(filename, password, encryptionMethod)

	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToZip)

	return err
}
