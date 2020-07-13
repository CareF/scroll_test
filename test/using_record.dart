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
  binding.reactToDeviceInput = true;

  Future<List<Duration>> handleInputDataRecord(List<PointerDataRecord> packet) async {
    assert(packet != null);
    assert(packet.isNotEmpty);
    return TestAsyncUtils.guard<List<Duration>>(() async {
      final List<Duration> handleTimeStampDiff = <Duration>[];
      DateTime startTime;
      for (final PointerDataRecord record in packet) {
        final DateTime now = binding.clock.now();
        startTime ??= now;
        final Duration timeDiff = record.timeStamp - now.difference(startTime);
        await binding.pump();
        await binding.delayed(timeDiff);
        handleTimeStampDiff.add(record.timeStamp - binding.clock.now().difference(startTime));
        binding.window.onPointerDataPacket(record.packet);
      }
      return handleTimeStampDiff;
    });
  }

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
    final List<PointerDataRecord> dataRecord = <PointerDataRecord>[
      for (final Map<String, dynamic> item in jsonObjects)
        PointerDataRecord(
          Duration(microseconds: (item['ts'] as int) - timeOffset),
          PointerDataPacket(
            data: <PointerData>[
              for (final dynamic event in item['events'] as List<dynamic>)
                deserializePointerData(event),
            ],
          ),
        ),
    ];

    await handleInputDataRecord(dataRecord);
    await tester.pumpAndSettle();
  }, semanticsEnabled: false);
}

/// A packet of input [PointerData]
class PointerDataRecord {
  /// creates
  PointerDataRecord(this.timeStamp, this.packet);

  /// times
  final Duration timeStamp;

  /// events
  final PointerDataPacket packet;
}

