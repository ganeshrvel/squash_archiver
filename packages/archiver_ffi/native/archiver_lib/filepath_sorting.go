package main

import (
	"sort"
	"strings"
)

// todo sorting by filepath isnt fully implemented
func sortPath(list []ArchiveFileInfo, orderDir ArchiveOrderDir) []ArchiveFileInfo {
	var splittedList []filePathListSortInfo

	for _, x := range list {
		splittedList = append(splittedList, filePathListSortInfo{
			pathSplitted: strings.Split(x.FullPath, PathSep),
			isDir:        x.IsDir,
			Mode:         x.Mode,
			Size:         x.Size,
			ModTime:      x.ModTime,
			Name:         x.Name,
			FullPath:     x.FullPath,
		})
	}

	_sortPath(&splittedList, orderDir, 0, 0, len(splittedList)-1)

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

func _sortPath(pathList *[]filePathListSortInfo, orderDir ArchiveOrderDir, index int, start int, end int) {
	_pathList := *pathList

	_trimmedSlice := _pathList[start : end+1]

	sort.SliceStable(_trimmedSlice, func(i, j int) bool {
		if orderDir == OrderDirDesc {
			return processFilepathSorting(&_trimmedSlice, j, i, index)
		}

		return processFilepathSorting(&_trimmedSlice, i, j, index)
	})

	var _buckets [][]int

	var _currentDirectoryName string
	var _lastInsertedBucketIndex = -1

	for i := start; i <= end; i += 1 {
		item := _pathList[i].pathSplitted[index]

		if _lastInsertedBucketIndex == -1 || item != _currentDirectoryName {
			_currentDirectoryName = item

			if _lastInsertedBucketIndex >= 0 && bucketSliceIndexExist(_buckets, _lastInsertedBucketIndex) {
				_buckets[_lastInsertedBucketIndex] = append(_buckets[_lastInsertedBucketIndex], i-1)
			}

			_lastInsertedBucketIndex += 1

			_buckets = append(_buckets, []int{i})
		}

		if i == end && bucketSliceIndexExist(_buckets, _lastInsertedBucketIndex) && len(_buckets[_lastInsertedBucketIndex]) < 2 {
			_buckets[_lastInsertedBucketIndex] = append(_buckets[_lastInsertedBucketIndex], i)
		}
	}

	if len(_buckets) > 0 {
		for i := 0; i < len(_buckets); i += 1 {
			if _buckets[i][0] != _buckets[i][1] {
				_sortPath(pathList, orderDir, index+1, _buckets[i][0], _buckets[i][1])
			}

		}
	}
}

func processFilepathSorting(pathList *[]filePathListSortInfo, i, j, index int) bool {
	_pathList := *pathList

	// if the last index of the splitted path list is empty and if it's a directory then bring it to the top
	if !filePathSliceIndexExist(_pathList[i], index+1) && (_pathList[i].isDir && _pathList[i].pathSplitted[index] == "" || _pathList[j].isDir && _pathList[j].pathSplitted[index] == "") {

		return _pathList[i].pathSplitted[index] < _pathList[j].pathSplitted[index]
	}

	// if the path is a directory then sort it
	if _pathList[i].isDir && _pathList[j].isDir || !_pathList[i].isDir && !_pathList[j].isDir {
		return _pathList[i].pathSplitted[index] < _pathList[j].pathSplitted[index]
	}

	// if the next index of the splitted path list exists then sort it
	if filePathSliceIndexExist(_pathList[i], index+1) {
		return _pathList[i].pathSplitted[index] < _pathList[j].pathSplitted[index]
	}

	// if the comparison is between a file and directory then return false always as file should come on top
	if _pathList[i].isDir && !_pathList[j].isDir {
		return false
	}

	return true
}

func filePathSliceIndexExist(s filePathListSortInfo, x int) bool {
	return len(s.pathSplitted) > x
}

func bucketSliceIndexExist(s [][]int, x int) bool {
	return len(s) > x
}
