package dart_api_dl

import "C"
import "strings"

type Errors string

const (
	ErrorOthers              Errors = "Some other error occured. Try again."
	ErrorFileNotFound        Errors = "ErrorFileNotFound"
	ErrorFileNotFoundPacking Errors = "ErrorFileNotFoundPacking"
	ErrorFilterPathNotFound  Errors = "ErrorFilterPathNotFound"
)

func processErrors(e error) string {
	if e == nil {
		return ""
	}

	errorType := string(ErrorOthers)

	if strings.Contains(e.Error(), "file does not exist") {
		errorType = string(ErrorFileNotFound)
	} else if strings.Contains(e.Error(), "path not found to filter") {
		errorType = string(ErrorFilterPathNotFound)
	} else if strings.Contains(e.Error(), "no such file or directory") {
		errorType = string(ErrorFileNotFoundPacking)
	}

	return errorType
}
