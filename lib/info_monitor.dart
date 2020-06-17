// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class InfoMonitor extends StatelessWidget {
  const InfoMonitor(this.info, {Key key}) : super(key: key);

  final String info;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.white.withOpacity(0.75),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(top: 15) + const EdgeInsets.all(5),
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          // minHeight: 100,
        ),
        child: Text(
          info,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
