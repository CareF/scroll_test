import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pointer_data_converter.dart';

extension TimedBindingBase on TestWidgetsFlutterBinding {
  Future<T> executeLater<T>(Duration duration, FutureOr<T> body()) async {
    if(this is AutomatedTestWidgetsFlutterBinding) {
      // assert(_currentFakeAsync != null);
      // addTime(duration);
      // _currentFakeAsync.elapse(duration);
      pump(duration);
      return body();
    } else if (this is LiveTestWidgetsFlutterBinding) {
      return Future<T>.delayed(duration, body);
    }
    throw UnimplementedError;
  }
}

extension GestureReplay on WidgetTester {
  Future<List<Duration>> handleInputEventsRecords(String jsonString) {
    return handlePointerEventPacket(pointerEventPackFromJson(jsonString,
        binding.window.devicePixelRatio));
  }

  Future<List<Duration>> handlePointerEventPacket(
      List<PointerEventPacket> packet, {DateTime startTime}) {
    assert(packet != null);
    assert(packet.isNotEmpty);
    return TestAsyncUtils.guard<List<Duration>>(() async {
      // hitTestHistory is an equivalence of _hitTests in [GestureBinding]
      final Map<int, HitTestResult> hitTestHistory = <int, HitTestResult>{};
      final List<Duration> handleTimeStampDiff = <Duration>[];
      Future<List<Duration>> result;
      for (final PointerEventPacket packet in packet) {
        final Completer<List<Duration>> completer = Completer<List<Duration>>();
        result = completer.future;
        final DateTime now = binding.clock.now();
        // make room for the following preparation
        startTime ??= now.add(const Duration(milliseconds: 20));
        final Duration timeDiff = packet.timeStamp - now.difference(startTime);
        if (timeDiff.isNegative) {
          // Flush all past events
          handleTimeStampDiff.add(timeDiff);
          // handleTimeStampDiff.add(Duration.zero);
          for (final PointerEvent event in packet.events) {
            _handlePointerEvent(event, hitTestHistory);
          }
          completer.complete(handleTimeStampDiff);
        } else {
          // TODO(CareF): reconsider the pumping strategy after
          // https://github.com/flutter/flutter/issues/60739 is fixed
          // await binding.pump();
          Timer(timeDiff, () async {
            handleTimeStampDiff.add(
                packet.timeStamp - binding.clock.now().difference(startTime));
            for (final PointerEvent event in packet.events) {
              _handlePointerEvent(event, hitTestHistory);
            }
            completer.complete(handleTimeStampDiff);
          });
//          await binding.executeLater(
//            timeDiff - const Duration(milliseconds: 1),
//            () async {
//              handleTimeStampDiff.add(
//                packet.timeStamp - binding.clock.now().difference(startTime));
//              for (final PointerEvent event in packet.events) {
//                _handlePointerEvent(event, hitTestHistory);
//              }
//            },
//          );
        }
      }
      // await binding.pump();
      // This makes sure that a gesture is completed, with no more pointers
      // active.
      assert(hitTestHistory.isEmpty);
      return result;
    });
  }

  // This is a parallel implementation of [GestureBinding._handlePointerEvent]
  // to make compatible with test bindings.
  void _handlePointerEvent(
      PointerEvent event, Map<int, HitTestResult> _hitTests) {
    HitTestResult hitTestResult;
    if (event is PointerDownEvent || event is PointerSignalEvent) {
      assert(!_hitTests.containsKey(event.pointer));
      hitTestResult = HitTestResult();
      binding.hitTest(hitTestResult, event.position);
      if (event is PointerDownEvent) {
        _hitTests[event.pointer] = hitTestResult;
      }
      assert(() {
        if (debugPrintHitTestResults)
          debugPrint('$event: $hitTestResult');
        return true;
      }());
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      hitTestResult = _hitTests.remove(event.pointer);
    } else if (event.down) {
      // Because events that occur with the pointer down (like
      // PointerMoveEvents) should be dispatched to the same place that their
      // initial PointerDownEvent was, we want to re-use the path we found when
      // the pointer went down, rather than do hit detection each time we get
      // such an event.
      hitTestResult = _hitTests[event.pointer];
    }
    assert(() {
      if (debugPrintMouseHoverEvents && event is PointerHoverEvent)
        debugPrint('$event');
      return true;
    }());
    if (hitTestResult != null ||
        event is PointerHoverEvent ||
        event is PointerAddedEvent ||
        event is PointerRemovedEvent) {
      binding.dispatchEvent(event, hitTestResult,
          source: TestBindingEventSource.test);
    }
  }
}
