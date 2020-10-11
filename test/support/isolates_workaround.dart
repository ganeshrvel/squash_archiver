// MIT License
//
// Copyright (c) 2019 Lukasz Wisniewski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

/// Workaround for bug: https://github.com/flutter/flutter/issues/24703
///
/// USAGE
///
/// ```
/// FlutterDriver driver;
/// IsolatesWorkaround workaround;
///
/// setUpAll(() async {
///   driver = await FlutterDriver.connect();
///   workaround = IsolatesWorkaround(driver);
///   await workaround.resumeIsolates();
/// });
///
/// tearDownAll(() async {
///   if (driver != null) {
///     await driver.close();
///     await workaround.tearDown();
///   }
/// });
/// ```
class IsolatesWorkaround {
  IsolatesWorkaround(this._driver, {this.log = false});
  final FlutterDriver _driver;
  final bool log;
  StreamSubscription _streamSubscription;

  /// workaround for isolates
  /// https://github.com/flutter/flutter/issues/24703
  Future<void> resumeIsolates() async {
    final vm = await _driver.serviceClient.getVM();
    // // unpause any paused isolated
    for (final isolateRef in vm.isolates) {
      final isolate = await isolateRef.load();
      if (isolate.isPaused) {
        isolate.resume();
        if (log) {
          print('Resuming isolate: ${isolate.numberAsString}:${isolate.name}');
        }
      }
    }
    if (_streamSubscription != null) {
      return;
    }
    _streamSubscription = _driver.serviceClient.onIsolateRunnable
        .asBroadcastStream()
        .listen((isolateRef) async {
      final isolate = await isolateRef.load();
      if (isolate.isPaused) {
        isolate.resume();
        if (log) {
          print('Resuming isolate: ${isolate.numberAsString}:${isolate.name}');
        }
      }
    });
  }

  Future<void> tearDown() async {
    if (_streamSubscription != null) {
      await _streamSubscription.cancel();
    }
  }
}
