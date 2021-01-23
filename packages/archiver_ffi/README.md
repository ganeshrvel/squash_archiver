# archiver_ffi

Minimum requirement
 - Dart 2.9.0

MacOS:
    Install Xcode.
    Install LLVM -  
    
```shell
brew install llvm

pub run ffigen:setup -I/usr/local/opt/llvm/include -L/usr/local/opt/llvm/lib
```

To generate the bindings
```shell
  pub run ffigen
```

To run
```shell
  "$HOME/Library/Application Support/fvm/current/bin/dart" ./lib/test_ffi.dart
```

shortcut
```shell 
flutter pub run ffigen && "$HOME/Library/Application Support/fvm/current/bin/dart" ./lib/test_ffi.dart

```



