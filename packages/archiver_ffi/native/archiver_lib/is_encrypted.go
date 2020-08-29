package main

import (
	"fmt"
	"github.com/yeka/zip"
	"path/filepath"
)

func (arc ZipArchive) isEncrypted() (bool, error) {
	_filename := arc.meta.filename

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

func isArchiveEncrypted(meta *ArchiveMeta) (bool, error) {
	_meta := *meta

	var utilsObj ArchiveUtils

	ext := filepath.Ext(_meta.filename)

	switch ext {
	case ".zip":
		utilsObj = ZipArchive{meta: _meta}

		break

	default:
		return false, fmt.Errorf("encryption check: file format not supported")
	}

	return utilsObj.isEncrypted()
}
