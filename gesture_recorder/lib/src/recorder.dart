import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pointer_data_converter.dart';

const String kRecordTimelineName = 'GestureBinding receive PointerEvents';

void enableGestureRecorder() {
  assert(WidgetsBinding.instance != null);
  final Window window = WidgetsBinding.instance.window;
  final PointerDataPacketCallback originalHandler = window.onPointerDataPacket;
  window.onPointerDataPacket = (PointerDataPacket packet) {
    Timeline.instantSync(
      kRecordTimelineName,
      arguments: <String, List<Map<String, dynamic>>>{
        'events': <Map<String, dynamic>>[
          for(final PointerData datum in packet.data)
            serializePointerData(datum),
        ],
      },
    );
    originalHandler(packet);
  };
}