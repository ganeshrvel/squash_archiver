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

	zipFilePathListMap := make(map[string]createZipFilePathList)

	for _, item := range _fileList {
		err = filepath.Walk(item, func(absFilepath string, fileInfo os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if isSymlink(fileInfo) {
				return nil
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

			isFileADir := fileInfo.IsDir()
			relativeFilePath = fixDirSlash(isFileADir, relativeFilePath)

			relativeFilePath = strings.TrimLeft(relativeFilePath, PathSep)

			// ignore the files if pattern matches
			if ignoreMatches.MatchesPath(relativeFilePath) {
				return nil
			}

			// when the commonpath is used to construct the relative path, the parent directories in the filepath list doesnt get written into the archive file
			if commonParentPath != "" && absFilepath != commonParentPath {
				if item == absFilepath {
					splittedPaths := strings.Split(relativeFilePath, PathSep)
					for pathIndex := range splittedPaths {
						_relativeFilePath := strings.Join(splittedPaths[:pathIndex+1], PathSep)

						// skip if filename is blank
						if _relativeFilePath == "" {
							continue
						}

						_absFilepath := fmt.Sprintf("%s%s%s", commonParentPath, PathSep, _relativeFilePath)

						isDir := true

						if pathIndex == len(splittedPaths)-1 {
							isDir = false
						}

						_absFilepath = fixDirSlash(isDir, _absFilepath)
						_relativeFilePath = fixDirSlash(isDir, _relativeFilePath)

						zipFilePathListMap[_absFilepath] = createZipFilePathList{
							absFilepath:      _absFilepath,
							relativeFilePath: _relativeFilePath,
							isDir:            isDir,
							fileInfo:         fileInfo,
						}
					}

					return nil
				}
			}

			absFilepath = fixDirSlash(isFileADir, absFilepath)

			zipFilePathListMap[absFilepath] = createZipFilePathList{
				absFilepath:      absFilepath,
				relativeFilePath: relativeFilePath,
				isDir:            isFileADir,
				fileInfo:         fileInfo,
			}

			return nil
		})

	}

	for _, item := range zipFilePathListMap {
		if _password == "" {
			if err := addFileToRegularZip(zipWriter, item.fileInfo, item.absFilepath, item.relativeFilePath); err != nil {
				return err
			}
		} else {
			if err := addFileToEncryptedZip(zipWriter, item.absFilepath, item.relativeFilePath, _password, _encryptionMethod); err != nil {
				return err
			}
		}
	}

	defer func() {
		if err := zipWriter.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	return err
}

func addFileToRegularZip(zipWriter *zip.Writer, fileInfo os.FileInfo, filename string, relativeFilename string) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	header, err := zip.FileInfoHeader(fileInfo)

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

func addFileToEncryptedZip(zipWriter *zip.Writer, filename string, relativeFilename string, password string,
	encryptionMethod zip.EncryptionMethod) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	writer, err := zipWriter.Encrypt(relativeFilename, password, encryptionMethod)

	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToZip)

	return err
}
