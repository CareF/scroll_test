import 'dart:convert' show json;
import 'dart:ui' as ui
    show PointerData, PointerChange, PointerDeviceKind, PointerSignalKind;

import 'package:flutter/gestures.dart';

// TODO(CareF): change serialize and deserialize to extension of toJson and fromJson

/// Serializes [ui.PointerData] to a json object.
///
/// Default values are omitted in the json object.
Map<String, dynamic> serializePointerData(ui.PointerData data) {
  // to perform null check on a variable rather than a getter
  return <String, dynamic>{
    if (data.timeStamp != Duration.zero)
      'timeStamp': data.timeStamp.inMicroseconds,
    if (data.change != ui.PointerChange.cancel) 'change': data.change.index,
    if (data.kind != ui.PointerDeviceKind.touch) 'kind': data.kind.index,
    if (data.signalKind != null) 'signalKind': data.signalKind.index,
    if (data.device != 0) 'device': data.device,
    if (data.pointerIdentifier != 0)
      'pointerIdentifier': data.pointerIdentifier,
    if (data.physicalX != 0.0) 'physicalX': data.physicalX,
    if (data.physicalY != 0.0) 'physicalY': data.physicalY,
    if (data.physicalDeltaX != 0.0) 'physicalDeltaX': data.physicalDeltaX,
    if (data.physicalDeltaY != 0.0) 'physicalDeltaY': data.physicalDeltaY,
    if (data.buttons != 0) 'buttons': data.buttons,
    if (data.obscured != false) 'obscured': data.obscured,
    if (data.synthesized != false) 'synthesized': data.synthesized,
    if (data.pressure != 0.0) 'pressure': data.pressure,
    if (data.pressureMin != 0.0) 'pressureMin': data.pressureMin,
    if (data.pressureMax != 0.0) 'pressureMax': data.pressureMax,
    if (data.distance != 0.0) 'distance': data.distance,
    if (data.distanceMax != 0.0) 'distanceMax': data.distanceMax,
    if (data.size != 0.0) 'size': data.size,
    if (data.radiusMajor != 0.0) 'radiusMajor': data.radiusMajor,
    if (data.radiusMinor != 0.0) 'radiusMinor': data.radiusMinor,
    if (data.radiusMin != 0.0) 'radiusMin': data.radiusMin,
    if (data.radiusMax != 0.0) 'radiusMax': data.radiusMax,
    if (data.orientation != 0.0) 'orientation': data.orientation,
    if (data.tilt != 0.0) 'tilt': data.tilt,
    if (data.platformData != 0) 'platformData': data.platformData,
    if (data.scrollDeltaX != 0.0) 'scrollDeltaX': data.scrollDeltaX,
    if (data.scrollDeltaY != 0.0) 'scrollDeltaY': data.scrollDeltaY,
  };
}

/// Deserializes [ui.PointerData] from a json object.
ui.PointerData deserializePointerData(dynamic value) {
  assert(value is Map<String, dynamic> || value is String);
  final Map<String, dynamic> jsonObject = value is String
      ? json.decode(value) as Map<String, dynamic>
      : value as Map<String, dynamic>;
  return ui.PointerData(
    timeStamp: Duration(microseconds: jsonObject['timeStamp'] as int ?? 0),
    change: ui.PointerChange.values[jsonObject['change'] as int ?? 0],
    kind: ui.PointerDeviceKind.values[jsonObject['kind'] as int ?? 0],
    signalKind: jsonObject.containsKey('signalKind')
        ? ui.PointerSignalKind.values[jsonObject['signalKind'] as int]
        : null,
    device: jsonObject['device'] as int ?? 0,
    pointerIdentifier: jsonObject['pointerIdentifier'] as int ?? 0,
    physicalX: jsonObject['physicalX'] as double ?? 0.0,
    physicalY: jsonObject['physicalY'] as double ?? 0.0,
    physicalDeltaX: jsonObject['physicalDeltaX'] as double ?? 0.0,
    physicalDeltaY: jsonObject['physicalDeltaY'] as double ?? 0.0,
    buttons: jsonObject['buttons'] as int ?? 0,
    obscured: jsonObject['obscured'] as bool ?? false,
    synthesized: jsonObject['synthesized'] as bool ?? false,
    pressure: jsonObject['pressure'] as double ?? 0.0,
    pressureMin: jsonObject['pressureMin'] as double ?? 0.0,
    pressureMax: jsonObject['pressureMax'] as double ?? 0.0,
    distance: jsonObject['distance'] as double ?? 0.0,
    distanceMax: jsonObject['distanceMax'] as double ?? 0.0,
    size: jsonObject['size'] as double ?? 0.0,
    radiusMajor: jsonObject['radiusMajor'] as double ?? 0.0,
    radiusMinor: jsonObject['radiusMinor'] as double ?? 0.0,
    radiusMin: jsonObject['radiusMin'] as double ?? 0.0,
    radiusMax: jsonObject['radiusMax'] as double ?? 0.0,
    orientation: jsonObject['orientation'] as double ?? 0.0,
    tilt: jsonObject['tilt'] as double ?? 0.0,
    platformData: jsonObject['platformData'] as int ?? 0,
    scrollDeltaX: jsonObject['scrollDeltaX'] as double ?? 0.0,
    scrollDeltaY: jsonObject['scrollDeltaY'] as double ?? 0.0,
  );
}
