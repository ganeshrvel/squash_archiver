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
	password          string
	fileList          []string
	gitIgnorePattern  []string
	encryptionMethod  zip.EncryptionMethod
	overwriteExisting bool
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
	meta ArchiveMeta // required
	read ArchiveRead // required for listing files
	pack ArchivePack // required for archiving files
}

type CommonArchive struct {
	meta ArchiveMeta // required
	read ArchiveRead // required for listing files
	pack ArchivePack // required for archiving files
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

type createZipFilePathList struct {
	absFilepath, relativeFilePath string
	isDir                         bool
	fileInfo                      os.FileInfo
}
