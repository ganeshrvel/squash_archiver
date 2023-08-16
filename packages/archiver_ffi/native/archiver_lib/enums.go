package main

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
	ErrorNotAValidArchiveFile  Errors = "ErrorNotAValidArchiveFile"
	ErrorFilterPathNotFound    Errors = "ErrorFilterPathNotFound"
	ErrorUnsupportedFileFormat Errors = "ErrorUnsupportedFileFormat"
	ErrorInvalidPassword       Errors = "ErrorInvalidPassword"
	ErrorPasswordRequired      Errors = "ErrorPasswordRequired"
	ErrorOperationNotPermitted Errors = "ErrorInvalidPassword"
)
