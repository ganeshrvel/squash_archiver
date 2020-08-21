package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	"log"
	"os"
	"path/filepath"
	"time"
)

func (arc ZipArchive) doPack() error {
	start := time.Now()

	_fileList := arc.pack.fileList

	if err := createZipFile(&arc, _fileList); err != nil {
		return err
	}

	elapsed := time.Since(start)
	log.Printf("time taken %s", elapsed)

	return nil
}

func (arc CommonArchive) doPack() error {
	start := time.Now()

	_filename := arc.meta.filename
	_fileList := arc.pack.fileList
	_overwriteExisting := arc.pack.overwriteExisting

	arcFileObj, err := archiver.ByExtension(_filename)

	if err != nil {
		return err
	}

	err = archiveFormat(&arcFileObj, "", _overwriteExisting)

	if err != nil {
		return err
	}

	w, ok := arcFileObj.(archiver.Archiver)
	if !ok {
		return fmt.Errorf("the archive command does not support the format")
	}

	var sources []string
	for _, src := range _fileList {
		srcs, err := filepath.Glob(src)

		if err != nil {
			return err
		}

		sources = append(sources, srcs...)
	}

	err = w.Archive(sources, _filename)

	if err != nil {
		return err
	}

	elapsed := time.Since(start)
	log.Printf("time taken %s", elapsed)

	return nil
}

func startPacking(meta *ArchiveMeta, pack *ArchivePack) error {
	_meta := *meta
	_pack := *pack

	_overwriteExisting := pack.overwriteExisting

	var arcPackObj ArchivePacker

	ext := filepath.Ext(_meta.filename)

	if _overwriteExisting && fileExists(_meta.filename) {
		if err := os.Remove(_meta.filename); err != nil {
			return err
		}
	}

	switch ext {
	case ".zip":
		arcPackObj = ZipArchive{meta: _meta, pack: _pack}

		break

	default:
		arcPackObj = CommonArchive{meta: _meta, pack: _pack}

		break
	}

	return arcPackObj.doPack()
}
