package main

import (
	"os"
	"time"
)

type baseArchive struct {
	filename   string
	password   string
	searchPath string
	orderby    string
	direction  string
}

type ZipArchive struct {
	baseArchive
}

type CommonArchive struct {
	baseArchive
}

type ArchiveManager interface {
	list() ([]ArchiveFileinfo, error)
}

type ArchiveFileinfo struct {
	Mode     os.FileMode
	Size     int64
	IsDir    bool
	ModTime  time.Time
	Name     string
	FullPath string
}
