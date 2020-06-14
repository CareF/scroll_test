// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class TopBarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        print('Selected: $value');
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        const PopupMenuItem<String>(
          value: 'Friends',
          child: MenuItemWithIcon(Icons.people, 'Friends', '5 new'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.event, 'Events', '12 upcoming'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.group, 'Groups', '14'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.image, 'Pictures', '12'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.near_me, 'Nearby', '33'),
        ),
        const PopupMenuItem<String>(
          value: 'Friends',
          child: MenuItemWithIcon(Icons.people, 'Friends', '5'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.event, 'Events', '12'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.group, 'Groups', '14'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.image, 'Pictures', '12'),
        ),
        const PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.near_me, 'Nearby', '33'),
        ),
      ],
    );
  }
}

class MenuItemWithIcon extends StatelessWidget {
  const MenuItemWithIcon(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: DefaultTextStyle.of(context).style.color,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(title),
        ),
        Text(subtitle, style: Theme.of(context).textTheme.caption),
      ],
    );
  }
}
