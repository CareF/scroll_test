// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
class IconWithText extends StatelessWidget {
  const IconWithText(this.icon, this.title);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            print('Pressed $title button');
          },
        ),
        Text(title),
      ],
    );
  }
}

class IconBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          IconWithText(Icons.thumb_up, 'Like'),
          IconWithText(Icons.comment, 'Comment'),
          IconWithText(Icons.share, 'Share'),
        ],
      ),
    );
  }
}