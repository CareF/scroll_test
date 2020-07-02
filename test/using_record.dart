import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e2e/e2e.dart';

import 'package:complex_layout/main.dart' as app;
//import 'package:flutter/services.dart' show rootBundle;
import 'package:complex_layout/scrollingRecord.dart';

Future<void> main() async {
  final E2EWidgetsFlutterBinding binding =
  E2EWidgetsFlutterBinding.ensureInitialized() as E2EWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets('E2E test with recorded input', (WidgetTester tester) async {
    // TODO(CareF): how to get a good relative path
    // dev_assets?
//    final String recordFile = await rootBundle.loadString('scrollingRecord.json');

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('info-switcher')));
    await tester.pumpAndSettle();

    await tester.handleInputEventsRecords(recordFile);
    await tester.pumpAndSettle();
  }, semanticsEnabled: false);
}
