package main

import (
	"github.com/ganeshrvel/archiver"
	ignore "github.com/sabhiram/go-gitignore"
	"os"
)

func compressFile(arc *CommonArchive, newArchiveFile interface{ archiver.Compressor }, fileList *[]string) error {
	_filename := arc.meta.filename
	_gitIgnorePattern := arc.pack.gitIgnorePattern
	_fileList := *fileList

	var ignoreList []string
	ignoreList = append(ignoreList, GlobalPatternDenylist...)
	ignoreList = append(ignoreList, _gitIgnorePattern...)

	ignoreMatches, _ := ignore.CompileIgnoreLines(ignoreList...)

	if !indexExists(_fileList, 0) {
		return nil
	}

	_source := _fileList[0]

	if ignoreMatches.MatchesPath(_source) {
		return nil
	}

	in, err := os.Open(_source)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.Create(_filename)
	if err != nil {
		return err
	}
	defer out.Close()

	err = newArchiveFile.Compress(in, out)
	if err != nil {
		return err
	}
	defer out.Close()

	return err
}
