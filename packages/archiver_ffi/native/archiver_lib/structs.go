package main

import (
	"os"
	"time"
)

type ArchiveFileInfo struct {
	Mode     os.FileMode
	Size     int64
	IsDir    bool
	ModTime  time.Time
	Name     string
	FullPath string
}

type ArchiveMeta struct {
	filename string
}

type ArchiveList struct {
	password          string
	listDirectoryPath string
	orderBy           ArchiveOrderBy
	orderDir        ArchiveOrderDir
	recursive         bool
}

type ZipArchive struct {
	ArchiveMeta
	ArchiveList
}

type CommonArchive struct {
	ArchiveMeta
	ArchiveList
}

type ArchiveLister interface {
	list() ([]ArchiveFileInfo, error)
	isEncrypted() (bool, error)
}
