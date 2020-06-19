// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('scrolling performance test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();

      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null)
        driver.close();
    });

    Future<void> testScrollPerf(
        String listKey, String summaryName, [int freq=60]) async {
      // The slight initial delay avoids starting the timing during a
      // period of increased load on the device. Without this delay, the
      // benchmark has greater noise.
      // See: https://github.com/flutter/flutter/issues/19434
      await Future<void>.delayed(const Duration(milliseconds: 250));

      await driver.forceGC();

      final Timeline timeline = await driver.traceAction(() async {
        // Find the scrollable stock list
        final SerializableFinder list = find.byValueKey(listKey);
        expect(list, isNotNull);

        // Scroll down
          await driver.scroll(
            list,
            0.0,
            -500.0,
            const Duration(milliseconds: 300),
            frequency: freq,
          );
          await Future<void>.delayed(const Duration(milliseconds: 500));
      });

      final TimelineSummary summary = TimelineSummary.summarize(timeline);
      summary.writeSummaryToFile(summaryName, pretty: true);
      summary.writeTimelineToFile(summaryName, pretty: true);
    }

    test('complex_layout_with_listener_scroll_perf_single', () async {
      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.byValueKey('info-switcher'));
      await testScrollPerf(
          'complex-scroll', 'complex_layout_with_listener_scroll_perf_single_60Hz', 60);
    });

    test('complex_layout_with_listener_scroll_perf_single', () async {
      await testScrollPerf(
          'complex-scroll', 'complex_layout_with_listener_scroll_perf_single_120Hz', 120);
    });
  });
}
