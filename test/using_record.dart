import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e2e/e2e.dart';

import 'package:complex_layout/main.dart' as app;
import 'package:complex_layout/scrollingRecord.dart';

import 'pointer_data_converter.dart';

Future<void> main() async {
  final E2EWidgetsFlutterBinding binding =
  E2EWidgetsFlutterBinding.ensureInitialized() as E2EWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets('E2E test with recorded input', (WidgetTester tester) async {

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('info-switcher')));
    await tester.pumpAndSettle();

    // await tester.handleInputEventsRecords(scrollingRecord);
    final List<Map<String, dynamic>> jsonObjects = <Map<String, dynamic>>[
      for (final dynamic item in json.decode(scrollingRecord) as List<dynamic>)
        item as Map<String, dynamic>
    ];
    final int timeOffset = jsonObjects[0]['ts'] as int;
    await tester.handleInputDataRecord(<PointerDataRecord>[
      for (final Map<String, dynamic> item in jsonObjects)
        PointerDataRecord(
          Duration(milliseconds: (item['ts'] as int) - timeOffset),
          PointerDataPacket(
            data: <PointerData>[
              for (final dynamic event in item['events'] as List<dynamic>)
                deserializePointerData(event),
            ],
          )
        )
    ]);
    await tester.pumpAndSettle();
  }, semanticsEnabled: false);
}
