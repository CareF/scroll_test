// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class InfoMonitor extends StatelessWidget {
  InfoMonitor(this.info, {Key key}) : super(key: key);

  final String info;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: Container(
      color: Colors.white.withOpacity(0.75),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.only(top: 15) + EdgeInsets.all(5),
      constraints: BoxConstraints(
        minWidth: double.infinity,
         // minHeight: 100,
      ),
      child: Text(
        info,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    ));
  }
}
