// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          BottomBarButton(Icons.new_releases, 'News'),
          BottomBarButton(Icons.people, 'Requests'),
          BottomBarButton(Icons.chat, 'Messenger'),
          BottomBarButton(Icons.bookmark, 'Bookmark'),
          BottomBarButton(Icons.alarm, 'Alarm'),
        ],
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton(this.icon, this.title);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(icon),
            onPressed: () {
              print('Pressed: $title');
            },
          ),
          Text(title, style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }
}
