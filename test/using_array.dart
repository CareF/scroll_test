// This test is a use case of flutter/flutter#60796
// the test should be run as:
// flutter drive -t test/using_array.dart --driver test_driver/scrolling_test_e2e_test.dart

import 'package:gesture_recorder/gesture_recorder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e2e/e2e.dart';

import 'package:complex_layout/main.dart' as app;

Future<void> main() async {
  final E2EWidgetsFlutterBinding binding =
    E2EWidgetsFlutterBinding.ensureInitialized() as E2EWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets('E2E test with array input', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final Offset location = tester.getCenter(find.byKey(
        const ValueKey<String>('complex-scroll')));
    const int moveEventNumber = 250;
    const Offset movePerRun = Offset(0.0, -400.0 / moveEventNumber);
    const Duration timePerRun = Duration(milliseconds: 2E3 ~/ moveEventNumber);
    final List<PointerEventPacket> records = <PointerEventPacket>[
      PointerEventPacket(Duration.zero, <PointerEvent>[
        // Typically PointerAddedEvent is not used in testers, but for records
        // captured on a device it is usually what start a gesture.
        PointerAddedEvent(
          timeStamp: Duration.zero,
          position: location,
        ),
        PointerDownEvent(
          timeStamp: Duration.zero,
          position: location,
          pointer: 1,
        ),
      ]),
      ...<PointerEventPacket>[
        for (int t=0; t < moveEventNumber; t++)
          PointerEventPacket(timePerRun * t, <PointerEvent>[
            PointerMoveEvent(
              timeStamp: timePerRun * t,
              position: location + movePerRun * t.toDouble(),
              pointer: 1,
              // It seems this delta always equals to current position minus
              // last position. Scrolling behavior depends on this delta rather
              // than the position difference. Not sure at what level this
              // equation is promised.
              delta: movePerRun,
            )
          ])
      ],
      PointerEventPacket(timePerRun * moveEventNumber, <PointerEvent>[
        PointerUpEvent(
          timeStamp: timePerRun * moveEventNumber,
          position: location + movePerRun * moveEventNumber.toDouble(),
          pointer: 1,
        )
      ])
    ];
    await tester.handlePointerEventPacket(records);

    await tester.pumpAndSettle();
  }, semanticsEnabled: false);
}
