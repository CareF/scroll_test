// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'global_setting.dart';

class SettingDrawer extends StatefulWidget {
  const SettingDrawer({Key key}) : super(key: key);

  @override
  _SettingDrawerState createState() => _SettingDrawerState();
}

class _SettingDrawerState extends State<SettingDrawer> {
  void _changeTheme(BuildContext context, bool value) {
    SettingConfig.of(context).lightTheme = value;
  }

  void _changeScrollMode(BuildContext context, ScrollMode mode) {
    SettingConfig.of(context).scrollMode = mode;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollMode currentMode = SettingConfig.of(context).scrollMode;
    return Drawer(
      // Note: for real apps, see the Gallery material Drawer demo. More
      // typically, a drawer would have a fixed header with a scrolling body
      // below it.
      child: ListView(
        key: const PageStorageKey<String>('gallery-drawer'),
        padding: EdgeInsets.zero,
        children: <Widget>[
          FancyDrawerHeader(),
          ListTile(
            key: const Key('scroll-switcher'),
            title: const Text('Scroll Mode'),
            onTap: () {
              // Don't need to setState since it's going to pop anyway.
              _changeScrollMode(
                  context,
                  currentMode == ScrollMode.complex
                      ? ScrollMode.tile
                      : ScrollMode.complex);
              Navigator.pop(context);
            },
            trailing:
            Text(currentMode == ScrollMode.complex ? 'Tile' : 'Complex'),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_5),
            title: const Text('Light'),
            onTap: () {
              if (!SettingConfig.of(context).lightTheme)
                setState(() {
                  _changeTheme(context, true);
                });
            },
            selected: SettingConfig.of(context).lightTheme,
            trailing: Radio<bool>(
              value: true,
              groupValue: SettingConfig.of(context).lightTheme,
              onChanged: (bool value) {
                if (SettingConfig.of(context).lightTheme != value)
                  setState(() {
                    _changeTheme(context, value);
                  });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_7),
            title: const Text('Dark'),
            onTap: () {
              if (SettingConfig.of(context).lightTheme)
                setState(() {
                  _changeTheme(context, false);
                });
            },
            selected: !SettingConfig.of(context).lightTheme,
            trailing: Radio<bool>(
              value: false,
              groupValue: SettingConfig.of(context).lightTheme,
              onChanged: (bool value) {
                if (SettingConfig.of(context).lightTheme != value)
                  setState(() {
                    _changeTheme(context, value);
                  });
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.hourglass_empty),
            title: const Text('Animate Slowly'),
            selected: SettingConfig.of(context).slowMode,
            onTap: () {
              setState(() {
                SettingConfig.of(context).toggleAnimationSpeed();
              });
            },
            trailing: Checkbox(
              value: SettingConfig.of(context).slowMode,
              onChanged: (bool value) {
                setState(() {
                  SettingConfig.of(context).toggleAnimationSpeed();
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Performance Overlay'),
            selected: SettingConfig.of(context).performanceOverlay,
            onTap: () {
              setState(() {
                SettingConfig.of(context).togglePerformanceOverlay();
              });
            },
            trailing: Checkbox(
              value: SettingConfig.of(context).performanceOverlay,
              onChanged: (bool value) {
                setState(() {
                  SettingConfig.of(context).performanceOverlay = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FancyDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      height: 200.0,
      child: const SafeArea(
        bottom: false,
        child: Placeholder(),
      ),
    );
  }
}
