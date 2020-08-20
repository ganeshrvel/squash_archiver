package main

import (
	"os"
	"time"
)

type listArchive struct {
	filename   string
	password   string
	searchPath string
	orderby    string
	direction  string
}

type zipArchive struct {
	listArchive
}

type commonArchive struct {
	listArchive
}

type archiveManager interface {
	list() ([]archiveFileinfo, error)
}

type archiveFileinfo struct {
	Mode     os.FileMode
	Size     int64
	IsDir    bool
	ModTime  time.Time
	Name     string
	FullPath string
}
