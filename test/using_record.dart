// This test is a use case of flutter/flutter#60796
// the test should be run as:
// flutter drive -t test/using_record.dart --driver test_driver/scrolling_test_e2e_test.dart

import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gesture_recorder/gesture_recorder.dart';
import 'package:e2e/e2e.dart';

import 'package:complex_layout/main.dart' as app;

import 'scrollingRecord.dart';

Future<void> main() async {
  final E2EWidgetsFlutterBinding binding =
    E2EWidgetsFlutterBinding.ensureInitialized() as E2EWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets('E2E test with recorded input', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // This also enables scroll widget position track and input event track
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('info-switcher')));
    await tester.pumpAndSettle();

    final List<Duration> delay = await tester.handleInputEventsRecords(scrollingRecord);
    Timeline.instantSync('simulation delay', arguments: <String, List<int>>{
      'delay': delay.map<int>((Duration e) => e.inMicroseconds).toList()
    });
    await tester.pumpAndSettle();
  }, semanticsEnabled: false);
}
