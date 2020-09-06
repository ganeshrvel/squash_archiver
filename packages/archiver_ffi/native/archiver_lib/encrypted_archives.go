package main

import (
	"fmt"
	"github.com/yeka/zip"
	"io/ioutil"
	"path/filepath"
)

func (arc ZipArchive) isEncrypted() (EncryptedArchiveInfo, error) {
	_filename := arc.meta.filename
	_password := arc.meta.password

	ai := EncryptedArchiveInfo{
		isEncrypted:     false,
		isValidPassword: false,
	}

	reader, err := zip.OpenReader(_filename)
	if err != nil {
		return ai, err
	}

	defer func() {
		if err = reader.Close(); err != nil {
			fmt.Printf("%v\n", err)
		}
	}()

	for _, file := range reader.File {
		if file.IsEncrypted() {
			ai.isEncrypted = true

			file.SetPassword(_password)

			r, err := file.Open()
			if err != nil {
				return ai, err
			}

			_, err = ioutil.ReadAll(r)
			if err != nil {
				return ai, nil
			}

			ai.isValidPassword = true

			return ai, err
		}
	}

	return ai, err
}

func isArchiveEncrypted(meta *ArchiveMeta) (EncryptedArchiveInfo, error) {
	_meta := *meta

	var utilsObj ArchiveUtils

	ext := filepath.Ext(_meta.filename)

	switch ext {
	case ".zip":
		utilsObj = ZipArchive{meta: _meta}

		break

	case ".rar":
		utilsObj = ZipArchive{meta: _meta}

		break

	default:
		ai := EncryptedArchiveInfo{
			isEncrypted:     false,
			isValidPassword: false,
		}

		return ai, fmt.Errorf("encryption check: file format not supported")
	}

	return utilsObj.isEncrypted()
}
