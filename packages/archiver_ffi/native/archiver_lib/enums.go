package main

type ArchiveOrderBy string

const (
	OrderBySize     ArchiveOrderBy = "Size"
	OrderByModTime  ArchiveOrderBy = "ModTime"
	OrderByName     ArchiveOrderBy = "Name"
	OrderByFullPath ArchiveOrderBy = "FullPath"
)

type ArchiveOrderDirection string

const (
	OrderDirAsc  ArchiveOrderDirection = "Asc"
	OrderDirDesc ArchiveOrderDirection = "Desc"
)
