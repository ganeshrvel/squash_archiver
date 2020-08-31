package main

import (
	"fmt"
	"github.com/yeka/zip"
	"io"
	"os"
)

func createZipFile(arc *ZipArchive, fileList []string, commonParentPath string) error {
	_filename := arc.meta.filename
	_password := arc.pack.password
	_gitIgnorePattern := arc.pack.gitIgnorePattern
	_encryptionMethod := arc.pack.encryptionMethod

	newZipFile, err := os.Create(_filename)
	if err != nil {
		return err
	}

	defer newZipFile.Close()

	zipWriter := zip.NewWriter(newZipFile)

	zipFilePathListMap := make(map[string]createZipFilePathList)

	err = processFilesForPacking(&zipFilePathListMap, &fileList, commonParentPath, &_gitIgnorePattern)
	if err != nil {
		return err
	}

	totalFiles := len(zipFilePathListMap)
	pInfo, ch := initPackingProgress(totalFiles)

	for absolutePath, item := range zipFilePathListMap {
		pInfo.packingProgress(ch, totalFiles, absolutePath)

		if _password == "" {
			if err := addFileToRegularZip(zipWriter, item.fileInfo, item.absFilepath, item.relativeFilePath); err != nil {
				return err
			}
		} else {
			if err := addFileToEncryptedZip(zipWriter, item.absFilepath, item.relativeFilePath, _password, _encryptionMethod); err != nil {
				return err
			}
		}

	}

	pInfo.closePacking(ch, totalFiles)

	defer func() {
		if err := zipWriter.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	return err
}

func addFileToRegularZip(zipWriter *zip.Writer, fileInfo os.FileInfo, filename string, relativeFilename string) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	header, err := zip.FileInfoHeader(fileInfo)

	if err != nil {
		return err
	}

	header.Name = relativeFilename

	// see http://golang.org/pkg/archive/zip/#pkg-constants
	header.Method = zip.Deflate

	writer, err := zipWriter.CreateHeader(header)
	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToZip)

	return err
}

func addFileToEncryptedZip(zipWriter *zip.Writer, filename string, relativeFilename string, password string,
	encryptionMethod zip.EncryptionMethod) error {
	fileToZip, err := os.Open(filename)

	if err != nil {
		return err
	}

	defer fileToZip.Close()

	writer, err := zipWriter.Encrypt(relativeFilename, password, encryptionMethod)

	if err != nil {
		return err
	}

	_, _ = io.Copy(writer, fileToZip)

	return err
}
