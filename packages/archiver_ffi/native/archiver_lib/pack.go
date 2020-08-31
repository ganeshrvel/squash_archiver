package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	ignore "github.com/sabhiram/go-gitignore"
	"github.com/wesovilabs/koazee"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func (arc ZipArchive) doPack() error {
	// TODO remove
	start := time.Now()

	_fileList := arc.pack.fileList

	commonParentPath := getParentPath(os.PathSeparator, _fileList...)

	if stringIndexExists(&_fileList, 0) && commonParentPath == _fileList[0] {
		commonParentPathSplitted := strings.Split(_fileList[0], PathSep)

		commonParentPath = strings.Join(commonParentPathSplitted[:len(commonParentPathSplitted)-1], PathSep)
	}

	if err := createZipFile(&arc, _fileList, commonParentPath); err != nil {
		return err
	}

	// TODO remove
	elapsed := time.Since(start)
	log.Printf("time taken %s", elapsed)

	return nil
}

func (arc CommonArchive) doPack() error {
	// TODO remove
	start := time.Now()

	_filename := arc.meta.filename
	_fileList := arc.pack.fileList
	_overwriteExisting := arc.pack.overwriteExisting

	arcFileObj, err := archiver.ByExtension(_filename)

	if err != nil {
		return err
	}

	err = archiveFormat(&arcFileObj, "", _overwriteExisting)

	if err != nil {
		return err
	}

	commonParentPath := getParentPath(os.PathSeparator, _fileList...)

	if stringIndexExists(&_fileList, 0) && commonParentPath == _fileList[0] {
		commonParentPathSplitted := strings.Split(_fileList[0], PathSep)

		commonParentPath = strings.Join(commonParentPathSplitted[:len(commonParentPathSplitted)-1], PathSep)
	}

	switch arcFileObj.(type) {
	case *archiver.Tar:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)
	case *archiver.TarGz:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)
	case *archiver.TarBz2:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)
	case *archiver.TarBrotli:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)
	case *archiver.TarLz4:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)
	case *archiver.TarSz:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)
	case *archiver.TarXz:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)
	case *archiver.TarZstd:
		err = packTarBalls(&arc, arcFileObj, &_fileList, commonParentPath)

	//case *archiver.Brotli:
	//case *archiver.Bz2:
	//case *archiver.Lz4:
	//case *archiver.Gz:
	//case *archiver.Snappy:
	//case *archiver.Xz:
	//case *archiver.Zstd:

	default:
		return fmt.Errorf("archive file format is not supported")
	}

	if err != nil {
		return err
	}

	// TODO remove
	elapsed := time.Since(start)
	log.Printf("time taken %s", elapsed)

	return nil
}

func startPacking(meta *ArchiveMeta, pack *ArchivePack) error {
	_meta := *meta
	_pack := *pack

	_overwriteExisting := pack.overwriteExisting

	var arcPackObj ArchivePacker

	ext := filepath.Ext(_meta.filename)

	if _overwriteExisting && fileExists(_meta.filename) {
		if err := os.Remove(_meta.filename); err != nil {
			return err
		}
	}

	switch ext {
	case ".zip":
		arcPackObj = ZipArchive{meta: _meta, pack: _pack}

		break

	default:
		arcPackObj = CommonArchive{meta: _meta, pack: _pack}

		break
	}

	return arcPackObj.doPack()
}

func getArchiveFilesRelativePath(absFilepath string, commonParentPath string) string {
	splittedFilepath := strings.Split(absFilepath, commonParentPath)

	_koazeeStream := koazee.StreamOf(splittedFilepath)
	lastItem := _koazeeStream.Last()

	return lastItem.String()
}

func processFilesForPacking(zipFilePathListMap *map[string]createZipFilePathList, fileList *[]string, commonParentPath string, gitIgnorePattern *[]string) error {
	_zipFilePathListMap := *zipFilePathListMap
	_fileList := *fileList

	var ignoreList []string
	ignoreList = append(ignoreList, GlobalPatternDenylist...)
	ignoreList = append(ignoreList, *gitIgnorePattern...)

	ignoreMatches, _ := ignore.CompileIgnoreLines(ignoreList...)

	for _, item := range _fileList {
		err := filepath.Walk(item, func(absFilepath string, fileInfo os.FileInfo, err error) error {
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

						_fileInfo, err := os.Lstat(_absFilepath)
						if err != nil {
							return err
						}

						isDir := _fileInfo.IsDir()

						_absFilepath = fixDirSlash(isDir, _absFilepath)
						_relativeFilePath = fixDirSlash(isDir, _relativeFilePath)

						_zipFilePathListMap[_absFilepath] = createZipFilePathList{
							absFilepath:      _absFilepath,
							relativeFilePath: _relativeFilePath,
							isDir:            isDir,
							fileInfo:         _fileInfo,
						}
					}

					return nil
				}
			}

			absFilepath = fixDirSlash(isFileADir, absFilepath)

			_zipFilePathListMap[absFilepath] = createZipFilePathList{
				absFilepath:      absFilepath,
				relativeFilePath: relativeFilePath,
				isDir:            isFileADir,
				fileInfo:         fileInfo,
			}

			return nil
		})

		if err != nil {
			return err
		}
	}

	return nil
}
