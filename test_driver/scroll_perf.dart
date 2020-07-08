// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:gesture_recorder/gesture_recorder.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:complex_layout/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  enableGestureRecorder();
  app.main();
}
