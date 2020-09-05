package main

import (
	"github.com/yeka/zip"
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
	filename         string
	password         string
	gitIgnorePattern []string
	encryptionMethod zip.EncryptionMethod
}

type ArchiveRead struct {
	listDirectoryPath string
	orderBy           ArchiveOrderBy
	orderDir          ArchiveOrderDir
	recursive         bool
}

type ArchivePack struct {
	fileList          []string
	overwriteExisting bool
}

type ArchiveUnpack struct {
	fileList    []string
	destination string
}

type filePathListSortInfo struct {
	splittedPaths [2]string
	IsDir         bool
	Mode          os.FileMode
	Size          int64
	ModTime       time.Time
	Name          string
	FullPath      string
}

type ZipArchive struct {
	meta   ArchiveMeta   // required
	read   ArchiveRead   // required for listing files
	pack   ArchivePack   // required for archiving files
	unpack ArchiveUnpack // required for unarchiving files
}

type CommonArchive struct {
	meta   ArchiveMeta   // required
	read   ArchiveRead   // required for listing files
	pack   ArchivePack   // required for archiving files
	unpack ArchiveUnpack // required for unarchiving files
}

type ArchiveReader interface {
	list() ([]ArchiveFileInfo, error)
}

type ArchiveUtils interface {
	isEncrypted() (bool, error)
}

type ArchivePacker interface {
	doPack() error
}

type ArchiveUnpacker interface {
	doUnpack() error
}

type createArchiveFileInfo struct {
	absFilepath, relativeFilePath string
	isDir                         bool
	fileInfo                      os.FileInfo
}

type extractArchiveFileInfo struct {
	absFilepath, name string
	fileInfo          os.FileInfo
	zipFileInfo       zip.File
}

type PackingProgressInfo struct {
	startTime          time.Time
	totalFiles         int
	progressCount      int
	currentFilename    string
	progressPercentage float32
}
