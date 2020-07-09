import 'dart:async';
import 'dart:io';

import 'package:e2e/common.dart' as e2e;
import 'package:flutter_driver/flutter_driver.dart';

Future<void> main() async => e2eDriver(traceTimeline: true, testName: 'e2e');

Future<void> e2eDriver({
  Duration timeout = const Duration(minutes: 1),
  bool traceTimeline = false,
  String testName,
}) async {
  assert(timeout != null);
  assert(!traceTimeline || testName != null);
  final FlutterDriver driver = await FlutterDriver.connect();
  String jsonResult;
  Timeline timeline;
  Future<void> runner() async {
    jsonResult = await driver.requestData(null, timeout: timeout);
  }

  if (traceTimeline) {
    timeline = await driver.traceAction(runner);
    // In the traceAction call runner is awaited.
  } else {
    await runner();
  }
  final e2e.Response response = e2e.Response.fromJson(jsonResult);
  await driver.close();

  if (response.allTestsPassed) {
    print('All tests passed.');
    if (traceTimeline) {
      final TimelineSummary summary = TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile(testName, pretty: true);
      await summary.writeSummaryToFile(testName, pretty: true);
    }
    exit(0);
  } else {
    print('Failure Details:\n${response.formattedFailureDetails}');
    exit(1);
  }
}