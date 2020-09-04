package main

import (
	"path/filepath"
)

func (arc ZipArchive) doUnpack() error {
	return startUnpackingZip(arc)
}

func (arc CommonArchive) doUnpack() error {

	return nil
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
