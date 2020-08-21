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

type ArchiveRead struct {
	password          string
	listDirectoryPath string
	orderBy           ArchiveOrderBy
	orderDir          ArchiveOrderDir
	recursive         bool
}

type ArchivePack struct {
	password string
}

type ZipArchive struct {
	meta ArchiveMeta
	read ArchiveRead
	pack ArchivePack
}

type CommonArchive struct {
	meta ArchiveMeta
	read ArchiveRead
	pack ArchivePack
}

type ArchiveReader interface {
	list() ([]ArchiveFileInfo, error)
}

type ArchiveUtils interface {
	isEncrypted() (bool, error)
}

type ArchivePacker interface {
	pack()
}
