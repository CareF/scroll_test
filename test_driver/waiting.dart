// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('scrolling performance test', ()
  {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();

      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null)
        driver.close();
    });

    test('Waiting for 5s...', () async {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.byValueKey('info-switcher'));

      await driver.forceGC();

      final Timeline timeline = await driver.traceAction(() async {
        // Find the scrollable stock list
        await Future<void>.delayed(const Duration(seconds: 5));
      });
      final TimelineSummary summary = TimelineSummary.summarize(timeline);
      summary.writeSummaryToFile('waiting', pretty: true);
      summary.writeTimelineToFile('waiting', pretty: true);
      final PointerDataRecord inputEvents = PointerDataRecord.filterFrom(timeline);
      inputEvents.writeToFile('scrollingRecord', pretty: true, asDart: true);
    });
  });
}
