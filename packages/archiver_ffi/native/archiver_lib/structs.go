package main

import (
	"os"
	"time"
)

type ArchiveMeta struct {
	filename string
}

type ArchiveList struct {
	password          string
	listDirectoryPath string
	orderby           string //TODO
	direction         string //TODO
	recursive         bool
}

type zipArchive struct {
	ArchiveMeta
	ArchiveList
}

type commonArchive struct {
	ArchiveMeta
	ArchiveList
}

type ArchiveLister interface {
	list() ([]archiveFileinfo, error)
	isEncrypted() (bool, error)
}

type archiveFileinfo struct {
	Mode     os.FileMode
	Size     int64
	IsDir    bool
	ModTime  time.Time
	Name     string
	FullPath string
}
