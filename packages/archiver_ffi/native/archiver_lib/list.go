package main

// TODO proper error handling. Return error back to the callee

import (
	"fmt"
	"github.com/sabhiram/go-gitignore"
	"path/filepath"
	"sort"
	"strings"
)

func sortFiles(list []ArchiveFileInfo, orderBy ArchiveOrderBy, orderDir ArchiveOrderDir) []ArchiveFileInfo {
	if orderDir == OrderDirNone {
		return list
	}

	switch orderBy {
	case OrderByFullPath:
		return sortPath(list, orderDir)

	case OrderByName:
		sort.SliceStable(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].Name > list[j].Name
			}

			return list[i].Name < list[j].Name
		})
		break
	case OrderByModTime:
		sort.SliceStable(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].ModTime.After(list[j].ModTime)
			}

			return list[i].ModTime.Before(list[j].ModTime)
		})
		break
	case OrderBySize:
		sort.SliceStable(list, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return list[i].Size > list[j].Size
			}

			return list[i].Size < list[j].Size
		})
		break
	}

	return list
}

func getFilteredFiles(fileInfo ArchiveFileInfo, listDirectoryPath string, recursive bool, gitIgnorePattern []string) (include bool) {
	var ignoreList []string
	ignoreList = append(ignoreList, GlobalPatternDenylist...)
	ignoreList = append(ignoreList, gitIgnorePattern...)

	ignoreMatches, _ := ignore.CompileIgnoreLines(ignoreList...)

	if ignoreMatches.MatchesPath(fileInfo.FullPath) {
		return false
	}

	isInPath := strings.HasPrefix(fileInfo.FullPath, listDirectoryPath)

	if isInPath {
		// dont return the directory path if it's listDirectoryPath. This will make sure that only files and sub directories are returned
		if listDirectoryPath == fileInfo.FullPath {
			return false
		}

		// if recursive mode is true return all files and subdirectories under the filtered path
		if recursive == true {
			return true
		}

		slashSplitListDirectoryPath := strings.Split(listDirectoryPath, PathSep)
		slashSplitListDirectoryPathLength := len(slashSplitListDirectoryPath)

		slashSplitFullPath := strings.Split(fileInfo.FullPath, PathSep)
		slashSplitFullPathLength := len(slashSplitFullPath)

		// if directory allow an extra '/' to figure out the subdirectory
		if fileInfo.IsDir && slashSplitFullPathLength < slashSplitListDirectoryPathLength+2 {
			return true
		}

		if !fileInfo.IsDir && slashSplitFullPathLength < slashSplitListDirectoryPathLength+1 {
			return true
		}
	}

	return false
}

func getArchiveFileList(meta *ArchiveMeta, read *ArchiveRead) ([]ArchiveFileInfo, error) {
	_meta := *meta
	_read := *read

	var arcObj ArchiveReader

	ext := filepath.Ext(meta.filename)

	// add a trailing slash to [listDirectoryPath] if missing
	if _read.listDirectoryPath != "" && !strings.HasSuffix(_read.listDirectoryPath, PathSep) {
		_read.listDirectoryPath = fmt.Sprintf("%s%s", _read.listDirectoryPath, PathSep)
	}

	switch ext {
	case ".zip":
		arcObj = ZipArchive{meta: _meta, read: _read}

		break

	default:
		arcObj = CommonArchive{meta: _meta, read: _read}

		break
	}

	return arcObj.list()
}
