Compile:
```shell script
$ go build -v -o build/archiver_lib.dylib -buildmode=c-shared archiver_lib.go
```


```
Open Xcode on macOS folder in the flutter project root
1. Open native/archiver_lib on finder
1. Drag the `archiver_lib.dylib` into the `Runner` targets in the left-hand side explorer. (just above GoogleService-Info.plist which is inside Runner tree)
2. Click on Runner which is in the left-hand side tree
3. Click on the `Build Phase` tab
4. Under `Copy Bundle Resources` click `+` and select `archiver_lib.dylib` and add it
5. Under `Link Binary with Libraries` drag and drop `archiver_lib.dylib` from the `Runner` tree
6. Make sure that `Status` is selected as `optional` under `Link Binary with Libraries`
7. Under `Bundle Framework` click `+` and select `archiver_lib.dylib` and add it
8. Make sure that `Code sign on copy` is checked for `archiver_lib.dylib` under `Bundle Framework`
9. Goto `General` tab
10. Under `Frameworks, Libraries and embedded contents`, `Embed` is set as `Ember & Sign` for `archiver_lib.dylib`



cross compile to osx (Not required):
CGO_ENABLED=1 GOOS=darwin go build -v -o squash_archiver_lib.dylib -buildmode=c-shared squash_archiver_lib.go
```


Install Go mholt package (https://github.com/mholt/archiver/issues/195)
```shell script
cd $GOPATH
go get github.com/pierrec/lz4 && cd $GOPATH/src/github.com/pierrec/lz4 && git fetch && git checkout v3.0.1
```
