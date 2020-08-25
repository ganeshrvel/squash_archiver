package main

import (
	"fmt"
	"github.com/denormal/go-gitignore"
	"github.com/mitchellh/go-homedir"
	"os"
	"path"
	"sort"
	"strings"
)

func fileExists(filename string) bool {
	info, err := os.Stat(filename)

	if os.IsNotExist(err) {
		return false
	}

	return !info.IsDir()
}

func getDesktopFiles(filename string) string {
	_home, _ := homedir.Dir()

	return fmt.Sprintf("%s%sDesktop%s%s", _home, PathSep, PathSep, filename)
}

func getHomeDirFiles(filename string) string {
	_home, _ := homedir.Dir()

	return fmt.Sprintf("%s%s%s", _home, PathSep, filename)
}

func gitIgnorePathAllow(filename string) (bool, error) {
	_, err := gitignore.NewFromFile("/my/.gitignore")

	if err != nil {
		return true, err
	}

	return true, nil
}

func getParentPath(sep byte, paths ...string) string {
	// Handle special cases.
	switch len(paths) {
	case 0:
		return ""
	case 1:
		return path.Clean(paths[0])
	}

	// Note, we treat string as []byte, not []rune as is often
	// done in Go. (And sep as byte, not rune). This is because
	// most/all supported OS' treat paths as string of non-zero
	// bytes. A filename may be displayed as a sequence of Unicode
	// runes (typically encoded as UTF-8) but paths are
	// not required to be valid UTF-8 or in any normalized form
	// (e.g. "é" (U+00C9) and "é" (U+0065,U+0301) are different
	// file names.
	c := []byte(path.Clean(paths[0]))

	// We add a trailing sep to handle the case where the
	// common prefix directory is included in the path list
	// (e.g. /home/user1, /home/user1/foo, /home/user1/bar).
	// path.Clean will have cleaned off trailing / separators with
	// the exception of the root directory, "/" (in which case we
	// make it "//", but this will get fixed up to "/" bellow).
	c = append(c, sep)

	// Ignore the first path since it's already in c
	for _, v := range paths[1:] {
		// Clean up each path before testing it
		v = path.Clean(v) + string(sep)

		// Find the first non-common byte and truncate c
		if len(v) < len(c) {
			c = c[:len(v)]
		}
		for i := 0; i < len(c); i++ {
			if v[i] != c[i] {
				c = c[:i]
				break
			}
		}
	}

	// Remove trailing non-separator characters and the final separator
	for i := len(c) - 1; i >= 0; i-- {
		if c[i] == sep {
			c = c[:i]
			break
		}
	}

	return string(c)
}

func isFile(name string) bool {
	if fi, err := os.Stat(name); err == nil {
		if fi.Mode().IsRegular() {
			return true
		}
	}

	return false
}

func isDir(name string) bool {
	if fi, err := os.Stat(name); err == nil {
		if fi.Mode().IsDir() {
			return true
		}
	}
	return false
}

func sortPath(list []ArchiveFileInfo, orderDir ArchiveOrderDir) {
	var splittedList [][]string
	for _, x := range list {
		splittedList = append(splittedList, strings.Split(x.FullPath, PathSep))
	}

	_sortPath(&splittedList, orderDir, 0, 0, len(splittedList)-1)
}

func _sortPath(pathList *[][]string, orderDir ArchiveOrderDir, index int, start int, end int) {
	_pathList := *pathList

	_trimmedSlice := _pathList[start : end+1]

	sort.Slice(_trimmedSlice, func(i, j int) bool {
		if orderDir == OrderDirDesc {
			return _trimmedSlice[i][index] > _trimmedSlice[j][index]
		}

		return _trimmedSlice[i][index] < _trimmedSlice[j][index]
	})

	var _buckets [][]int

	var _currentDirectoryName string
	var _lastInsertedBucketIndex = -1

	for i := start; i <= end; i += 1 {
		item := _pathList[i][index]

		if _lastInsertedBucketIndex == -1 || item != _currentDirectoryName {
			_currentDirectoryName = item

			if _lastInsertedBucketIndex >= 0 && _lastInsertedBucketIndex < len(_buckets) {
				_buckets[_lastInsertedBucketIndex] = append(_buckets[_lastInsertedBucketIndex], i-1)
			}

			_lastInsertedBucketIndex += 1

			_buckets = append(_buckets, []int{i})
		}

		if i == end {
			if len(_buckets[_lastInsertedBucketIndex]) < 2 {
				_buckets[_lastInsertedBucketIndex] = append(_buckets[_lastInsertedBucketIndex], i)
			}
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
