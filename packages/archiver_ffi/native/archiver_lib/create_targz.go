package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	ignore "github.com/sabhiram/go-gitignore"
	"github.com/wesovilabs/koazee"
	"os"
	"path/filepath"
	"strings"
)

func createTarGzFile(arc *CommonArchive, newArchiveFile *archiver.TarGz, _fileList []string, commonParentPath string) error {
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
