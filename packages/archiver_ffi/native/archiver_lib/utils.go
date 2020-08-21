package main

import (
	"fmt"
	"github.com/denormal/go-gitignore"
	"github.com/mitchellh/go-homedir"
	"os"
)

func fileExists(filename string) bool {
	info, err := os.Stat(filename)

	if os.IsNotExist(err) {
		return false
	}

	return !info.IsDir()
}

func getDesktopFiles(filename string) string {
	_home, _ := homedir.Dir()

	return fmt.Sprintf("%s/Desktop/%s", _home, filename)
}

func gitIgnorePathAllow(filename string) (bool, error) {
	_, err := gitignore.NewFromFile("/my/.gitignore")

	if err != nil {
		return true, err
	}

	return true, nil
}
