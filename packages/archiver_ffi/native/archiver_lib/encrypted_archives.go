package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	"github.com/yeka/zip"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func isRarArchiveEncrypted(arcValues *archiver.Rar, filename, password string) (bool, error) {
	arcValues.Password = password

	file, err := os.Open(filename)
	if err != nil {
		return false, err
	}

	defer file.Close()

	err = arcValues.Open(file, 0)
	if err != nil {
		return false, err
	}
	defer func() {
		if err := arcValues.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	r, err := arcValues.Read()

	defer func() {
		if r == (archiver.File{}) {
			return
		}

		if err := r.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	if err != nil {
		if strings.Contains(err.Error(), "incorrect password") {
			return true, nil
		}

		return false, err
	}

	return false, nil
}

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
			defer func() {
				if err = r.Close(); err != nil {
					fmt.Printf("%v\n", err)
				}
			}()

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

func (arc CommonArchive) isEncrypted() (EncryptedArchiveInfo, error) {
	_filename := arc.meta.filename
	_password := arc.meta.password

	ai := EncryptedArchiveInfo{
		isEncrypted:     false,
		isValidPassword: false,
	}

	arcFileObj, err := archiver.ByExtension(_filename)

	if err != nil {
		return ai, err
	}

	err = archiveFormat(&arcFileObj, _password, OverwriteExisting)

	if err != nil {
		return ai, err
	}

	switch arcValues := arcFileObj.(type) {
	case *archiver.Rar:
		// check if the rar file is encrypted
		r1, err := isRarArchiveEncrypted(arcValues, _filename, "")
		if err != nil {
			return ai, err
		}

		// check if the password is correct
		if r1 {
			ai.isEncrypted = true

			r2, err := isRarArchiveEncrypted(arcValues, _filename, _password)
			ai.isValidPassword = !r2

			if err != nil {
				return ai, err
			}
		}

		return ai, err

	default:
		return ai, nil
	}
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
		utilsObj = CommonArchive{meta: _meta}

		break

	default:
		ai := EncryptedArchiveInfo{
			isEncrypted:     false,
			isValidPassword: false,
		}

		return ai, nil
	}

	return utilsObj.isEncrypted()
}
