import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gesture_recorder/gesture_recorder.dart';

void main () {
  testWidgets('Input event array', (WidgetTester tester) async {
    final List<String> logs = <String>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Listener(
          onPointerDown: (PointerDownEvent event) => logs.add('down ${event.buttons}'),
          onPointerMove: (PointerMoveEvent event) => logs.add('move ${event.buttons}'),
          onPointerUp: (PointerUpEvent event) => logs.add('up ${event.buttons}'),
          child: const Text('test'),
        ),
      ),
    );

    final Offset location = tester.getCenter(find.text('test'));
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
          buttons: kSecondaryMouseButton,
          pointer: 1,
        ),
      ]),
      ...<PointerEventPacket>[
        for (Duration t = const Duration(milliseconds: 5);
        t < const Duration(milliseconds: 80);
        t += const Duration(milliseconds: 16))
          PointerEventPacket(t, <PointerEvent>[
            PointerMoveEvent(
              timeStamp: t - const Duration(milliseconds: 1),
              position: location,
              buttons: kSecondaryMouseButton,
              pointer: 1,
            )
          ])
      ],
      PointerEventPacket(const Duration(milliseconds: 80), <PointerEvent>[
        PointerUpEvent(
          timeStamp: const Duration(milliseconds: 79),
          position: location,
          buttons: kSecondaryMouseButton,
          pointer: 1,
        )
      ])
    ];
    await tester.handlePointerEventPack(records);

    const String b = '$kSecondaryMouseButton';
    for(int i = 0; i < logs.length; i++) {
      if (i == 0)
        expect(logs[i], 'down $b');
      else if (i != logs.length - 1)
        expect(logs[i], 'move $b');
      else
        expect(logs[i], 'up $b');
    }
  });
}