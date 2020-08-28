package main

import (
	"path/filepath"
	"sort"
)

func sortPath(list []ArchiveFileInfo, orderDir ArchiveOrderDir) []ArchiveFileInfo {
	var splittedList []filePathListSortInfo

	for _, x := range list {
		splittedList = append(splittedList, filePathListSortInfo{
			pathSplitted: [2]string{filepath.Dir(x.FullPath), filepath.Base(x.FullPath)},
			isDir:        x.IsDir,
			Mode:         x.Mode,
			Size:         x.Size,
			ModTime:      x.ModTime,
			Name:         x.Name,
			FullPath:     x.FullPath,
		})
	}

	var resultList []ArchiveFileInfo

	for _, x := range splittedList {
		resultList = append(resultList, ArchiveFileInfo{
			Mode:     x.Mode,
			Size:     x.Size,
			IsDir:    x.isDir,
			ModTime:  x.ModTime,
			Name:     x.Name,
			FullPath: x.FullPath,
		})
	}

	return resultList
}

func _sortPath(pathList *[]ArchiveFileInfo, orderDir ArchiveOrderDir) {
	_pathList := *pathList

	sort.SliceStable(_pathList, func(i, j int) bool {
		if orderDir == OrderDirDesc {
			return _pathList[i].splittedPath[0] > _pathList[j].splittedPath[0]
		}

		return _pathList[i].splittedPath[0] < _pathList[j].splittedPath[0]
	})

	count := 0
	for count < len(_pathList)-1 {
		var bucket = [2]int{count, len(_pathList)}

		for k, _ := range _pathList[count:] {
			if orderDir == OrderDirDesc && count+k >= len(_pathList)-1 {
				break
			}

			if _pathList[count+k].splittedPath[0] != _pathList[count+k+1].splittedPath[0] {

				bucket[1] = count + k - 1
				count = count + k

				break
			}

		}

		trimmedPathList := _pathList[bucket[0] : bucket[1]+2]

		sort.SliceStable(trimmedPathList, func(i, j int) bool {
			if orderDir == OrderDirDesc {
				return trimmedPathList[i].splittedPath[1] > trimmedPathList[j].splittedPath[1]
			}

			return trimmedPathList[i].splittedPath[1] < trimmedPathList[j].splittedPath[1]
		})

		count += 1
	}
}
