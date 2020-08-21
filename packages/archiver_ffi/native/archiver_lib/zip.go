package main

import (
	"fmt"
	"github.com/yeka/zip"
	"io"
	"os"
	"path/filepath"
)

func createZipFile(arc *ZipArchive, _fileList []string) error {
	_filename := arc.meta.filename
	_password := arc.pack.password
	_encryptionMethod := arc.pack.encryptionMethod

	newZipFile, err := os.Create(_filename)
	if err != nil {
		return err
	}

	defer newZipFile.Close()

	zipWriter := zip.NewWriter(newZipFile)

	//todo _fileList[0]
	err = filepath.Walk(_fileList[0], func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() {
			return nil
		}

		if _password != "" {
			if err = addFileToRegularZip(zipWriter, path); err != nil {
				return err
			}
		} else {
			if err = addFileToEncryptedZip(zipWriter, path, _password, _encryptionMethod); err != nil {
				return err
			}
		}

		return nil
	})

	defer func() {
		if err := zipWriter.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	return err
}

func addFileToRegularZip(zipWriter *zip.Writer, filename string) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	// Get the file information
	// Using FileInfoHeader() above only uses the basename of the file. If we want
	// to preserve the folder structure we can overwrite this with the full path.
	info, err := fileToZip.Stat()
	if err != nil {
		return err
	}

	header, err := zip.FileInfoHeader(info)

	if err != nil {
		return err
	}

	header.Name = filename

	// see http://golang.org/pkg/archive/zip/#pkg-constants
	header.Method = zip.Deflate

	writer, err := zipWriter.CreateHeader(header)
	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToZip)

	return err
}

func addFileToEncryptedZip(zipWriter *zip.Writer, filename string, password string,
	encryptionMethod zip.EncryptionMethod) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	// Get the file information
	// Using FileInfoHeader() above only uses the basename of the file. If we want
	// to preserve the folder structure we can overwrite this with the full path.

	writer, err := zipWriter.Encrypt(filename, password, encryptionMethod)

	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToZip)

	return err
}
