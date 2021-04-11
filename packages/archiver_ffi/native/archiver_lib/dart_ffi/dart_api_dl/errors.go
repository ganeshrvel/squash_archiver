package dart_api_dl

import "C"
import "strings"

func processErrors(e error, taskType TaskType) string {
	if e == nil {
		return ""
	}

	errorType := string(ErrorOthers)

	if strings.Contains(e.Error(), "file does not exist") {
		errorType = string(ErrorFileNotFound)
	} else if strings.Contains(e.Error(), "path not found to filter") {
		errorType = string(ErrorFilterPathNotFound)
	} else if strings.Contains(e.Error(), "no such file or directory") {
		if taskType == TaskPackFiles {
			errorType = string(ErrorFileNotFoundToPack)
		} else {
			errorType = string(ErrorFileNotFound)
		}

	} else if strings.Contains(e.Error(), "format unrecognized by filename") {
		errorType = string(ErrorUnsupportedFileFormat)
	} else if strings.Contains(e.Error(), "invalid password") {
		errorType = string(ErrorInvalidPassword)
	} else if strings.Contains(e.Error(), "password is required") {
		errorType = string(ErrorPasswordRequired)
	} else if strings.Contains(e.Error(), "operation not permitted") {
		errorType = string(ErrorOperationNotPermitted)
	}

	return errorType
}
