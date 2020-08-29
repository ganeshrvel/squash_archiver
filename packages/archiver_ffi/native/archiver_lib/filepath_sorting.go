package main

import (
	"github.com/kr/pretty"
	"path/filepath"
	"sort"
)

func sortPath(list []ArchiveFileInfo, orderDir ArchiveOrderDir) []ArchiveFileInfo {
	var filePathList []filePathListSortInfo

	for _, x := range list {
		var splittedPaths [2]string

		if !x.IsDir {
			splittedPaths = [2]string{filepath.Dir(x.FullPath), x.Name}
		} else {
			splittedPaths = [2]string{filepath.Dir(x.FullPath), ""}
		}

		filePathList = append(filePathList, filePathListSortInfo{
			IsDir:         x.IsDir,
			FullPath:      x.FullPath,
			splittedPaths: splittedPaths,
			Mode:          x.Mode,
			Size:          x.Size,
			ModTime:       x.ModTime,
			Name:          x.Name,
		})
	}

	_sortPath(&filePathList, orderDir)

	var resultList []ArchiveFileInfo

	for _, x := range filePathList {
		resultList = append(resultList, ArchiveFileInfo{
			Mode:     x.Mode,
			Size:     x.Size,
			IsDir:    x.IsDir,
			ModTime:  x.ModTime,
			Name:     x.Name,
			FullPath: x.FullPath,
		})
	}

	return resultList
}

func _sortPath(pathList *[]filePathListSortInfo, orderDir ArchiveOrderDir) {
	_pathList := *pathList

	sort.SliceStable(_pathList, func(i, j int) bool {
		if orderDir == OrderDirDesc {
			return _pathList[i].splittedPaths[0] > _pathList[j].splittedPaths[0]
		}

		return _pathList[i].splittedPaths[0] < _pathList[j].splittedPaths[0]
	})

	count := 0
	for count < len(_pathList)-1 {
		start := count
		end := len(_pathList)

		for k, _ := range _pathList[count:] {
			if count+k+1 >= len(_pathList) {
				break
			}

			if _pathList[count+k].splittedPaths[0] != _pathList[count+k+1].splittedPaths[0] {

				end = count + k + 1
				count = count + k

				break
			}

		}

		trimmedPathList := _pathList[start : end]

		sort.SliceStable(trimmedPathList, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return trimmedPathList[i].splittedPaths[1] > trimmedPathList[j].splittedPaths[1]
			}

			pretty.Println(trimmedPathList[i].splittedPaths[1], trimmedPathList[j].splittedPaths[1])

			return trimmedPathList[i].splittedPaths[1] < trimmedPathList[j].splittedPaths[1]
		})

		count += 1
	}
}
