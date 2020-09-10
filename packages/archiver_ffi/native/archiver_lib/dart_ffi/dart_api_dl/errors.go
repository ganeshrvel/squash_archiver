package dart_api_dl

import "strings"

type Errors string

const (
	ErrorOthers       Errors = "Some other error occured. Try again."
	ErrorFileNotExist Errors = "ErrorFileNotExist"
)

func (ei *ErrorInfo) processErrors(e error) {
	if e == nil {
		return
	}

	ei.error = e.Error()
	ei.errorType = string(ErrorOthers)

	if strings.Contains(ei.error, "file does not exist") {
		ei.errorType = string(ErrorFileNotExist)
	}
}
