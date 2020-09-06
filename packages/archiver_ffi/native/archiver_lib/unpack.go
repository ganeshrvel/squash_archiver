package main

import (
	"fmt"
	"github.com/ganeshrvel/archiver"
	"path/filepath"
)

func (arc ZipArchive) doUnpack() error {
	return startUnpackingZip(arc)
}

func (arc CommonArchive) doUnpack() error {
	_filename := arc.meta.filename
	_password := arc.meta.password

	arcFileObj, err := archiver.ByExtension(_filename)

	if err != nil {
		return err
	}

	err = archiveFormat(&arcFileObj, _password, OverwriteExisting)

	if err != nil {
		return err
	}

	var arcWalker, ok = arcFileObj.(archiver.Walker)
	if !ok {
		return fmt.Errorf("some error occured while reading the archive")
	}

	return startUnpackingCommonArchives(arc, arcWalker)
}

func startUnpacking(meta *ArchiveMeta, pack *ArchiveUnpack) error {
	_meta := *meta
	_pack := *pack

	var arcUnpackObj ArchiveUnpacker

	ext := filepath.Ext(_meta.filename)

	switch ext {
	case ".zip":
		arcUnpackObj = ZipArchive{meta: _meta, unpack: _pack}

		break

	default:
		arcUnpackObj = CommonArchive{meta: _meta, unpack: _pack}

		break
	}

	return arcUnpackObj.doUnpack()
}
