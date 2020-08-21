package main

import (
	"fmt"
	"github.com/mholt/archiver"
)

func archiveFormat(arcFileObj *interface{}, password string) error {
	const (
		overwriteExisting      = true
		mkdirAll               = true
		implicitTopLevelFolder = false
		continueOnError        = true
		compressionLevel       = 9
		selectiveCompression   = false
	)

	tarObj := &archiver.Tar{
		OverwriteExisting:      overwriteExisting,
		MkdirAll:               mkdirAll,
		ImplicitTopLevelFolder: implicitTopLevelFolder,
		ContinueOnError:        continueOnError,
	}

	_arcFileObj := *arcFileObj

	// refer https://github.com/mholt/archiver/blob/master/cmd/arc/main.go for more
	switch arcValues := _arcFileObj.(type) {
	case *archiver.Rar:
		arcValues.OverwriteExisting = overwriteExisting
		arcValues.MkdirAll = mkdirAll
		arcValues.ImplicitTopLevelFolder = implicitTopLevelFolder
		arcValues.ContinueOnError = continueOnError
		arcValues.Password = password

		break

	case *archiver.Tar:
		arcValues = tarObj

		break

	case *archiver.TarBrotli:
		arcValues.Tar = tarObj
		arcValues.Quality = compressionLevel

		break

	case *archiver.TarBz2:
	case *archiver.TarGz:
	case *archiver.TarLz4:
		arcValues.Tar = tarObj
		arcValues.CompressionLevel = compressionLevel

		break

	case *archiver.TarSz:
	case *archiver.TarXz:
	case *archiver.TarZstd:
		arcValues.Tar = tarObj

		break

	case *archiver.Zip:
		arcValues.CompressionLevel = compressionLevel
		arcValues.OverwriteExisting = overwriteExisting
		arcValues.MkdirAll = mkdirAll
		arcValues.SelectiveCompression = selectiveCompression
		arcValues.ImplicitTopLevelFolder = implicitTopLevelFolder
		arcValues.ContinueOnError = continueOnError

		break

	case *archiver.Brotli:
		arcValues.Quality = compressionLevel

		break

	case *archiver.Bz2:
	case *archiver.Lz4:
	case *archiver.Gz:
		arcValues.CompressionLevel = compressionLevel

		break
	case *archiver.Snappy:
	case *archiver.Xz:
	case *archiver.Zstd:
		break

	default:
		return fmt.Errorf("format does not support customization")
	}

	return nil
}
