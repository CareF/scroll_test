import 'package:flutter/material.dart';
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

    await tester.handleInputEventsRecords(scrollingRecord);
    await tester.pumpAndSettle();
  }, semanticsEnabled: false);
}
