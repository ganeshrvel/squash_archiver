import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/models/list_archive.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/utils/archiver/archiver_provider.dart';

@lazySingleton
class Archiver {
  final ArchiverFfi _ffiLib =
      archiverFfiProviderContainer.read(archiverFfiProvider);

  Future<DC<Exception, ListArchiveResult>> listFiles(String filename) async {
    final _params = ListArchive(
      filename: filename,
    );

    return compute(_fetchFiles, _params);
  }
}

Future<DC<Exception, ListArchiveResult>> _fetchFiles(
  ListArchive params,
) async {
  final _ffiLib = archiverFfiProviderContainer.read(archiverFfiProvider);

  return _ffiLib.listArchive(params);
}
