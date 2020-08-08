import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:archiver_ffi/archiver_ffi.dart';

void main() {
  const MethodChannel channel = MethodChannel('archiver_ffi');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ArchiverFfi.platformVersion, '42');
  });
}
