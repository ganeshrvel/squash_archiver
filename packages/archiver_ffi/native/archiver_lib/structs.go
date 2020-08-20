package main

import (
	"os"
	"time"
)

type listArchive struct {
	filename          string
	password          string
	listDirectoryPath string
	orderby           string //TODO
	direction         string //TODO
	recursive         bool
}

type zipArchive struct {
	listArchive
}

type commonArchive struct {
	listArchive
}

type archiveManager interface {
	list() ([]archiveFileinfo, error)
	isEncryped() (bool, error)
}

type archiveFileinfo struct {
	Mode     os.FileMode
	Size     int64
	IsDir    bool
	ModTime  time.Time
	Name     string
	FullPath string
}
