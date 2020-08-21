package main

import (
	"fmt"
	"github.com/yeka/zip"
	"path/filepath"
)

func (arc zipArchive) isEncrypted() (bool, error) {
	_filename := arc.filename

	reader, err := zip.OpenReader(_filename)
	if err != nil {
		return false, err
	}

	defer func() {
		if err = reader.Close(); err != nil {
			fmt.Printf("%v\n", err)
		}
	}()

	for _, file := range reader.File {
		if file.IsEncrypted() {

			return true, err
		}
	}

	return false, err
}

func (arc commonArchive) isEncrypted() (bool, error) {
	return false, nil
}

func isArchiveEncrypted(filename string) (bool, error) {
	var arcObj ArchiveLister

	ext := filepath.Ext(filename)
	_meta := ArchiveMeta{filename: filename}

	switch ext {
	case ".zip":
		arcObj = zipArchive{_meta, ArchiveList{}}

		break

	default:
		return false, fmt.Errorf("encryption check: file format not supported")
	}

	return arcObj.isEncrypted()
}
