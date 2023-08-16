package main

import "strings"

func processErrors(e error, taskType TaskType) string {
	if e == nil {
		return ""
	}

	errorType := string(ErrorOthers)
	err := strings.ToLower(e.Error())

	if strings.Contains(err, "file does not exist") {
		errorType = string(ErrorFileNotFound)
	} else if strings.Contains(err, "not a valid") {
		errorType = string(ErrorNotAValidArchiveFile)
	} else if strings.Contains(err, "path not found to filter") {
		errorType = string(ErrorFilterPathNotFound)
	} else if strings.Contains(err, "no such file or directory") {
		if taskType == TaskPackFiles {
			errorType = string(ErrorFileNotFoundToPack)
		} else {
			errorType = string(ErrorFileNotFound)
		}

	} else if strings.Contains(err, "format unrecognized by filename") {
		errorType = string(ErrorUnsupportedFileFormat)
	} else if strings.Contains(err, "invalid password") {
		errorType = string(ErrorInvalidPassword)
	} else if strings.Contains(err, "password is required") {
		errorType = string(ErrorPasswordRequired)
	} else if strings.Contains(err, "operation not permitted") {
		errorType = string(ErrorOperationNotPermitted)
	}

	return errorType
}
