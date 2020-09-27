package dart_api_dl

type TaskType string

const (
	TaskListArchive        TaskType = "TaskListArchive"
	TaskIsArchiveEncrypted TaskType = "TaskIsArchiveEncrypted"
	TaskPackFiles          TaskType = "TaskPackFiles"
	TaskUnpackFiles        TaskType = "UnpackFiles"
)

type Errors string

const (
	ErrorOthers                Errors = "Some other error occured. Try again."
	ErrorFileNotFound          Errors = "ErrorFileNotFound"
	ErrorFileNotFoundToPack    Errors = "ErrorFileNotFoundToPack"
	ErrorFilterPathNotFound    Errors = "ErrorFilterPathNotFound"
	ErrorUnsupportedFileFormat Errors = "ErrorUnsupportedFileFormat"
	ErrorInvalidPassword       Errors = "ErrorInvalidPassword"
)
