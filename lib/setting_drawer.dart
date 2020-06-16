// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'model_binding.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

enum ScrollMode { complex, tile }

@immutable
class SettingConfig {
  const SettingConfig({
    this.lightTheme = true,
    this.scrollMode = ScrollMode.complex,
    this.performanceOverlay = false,
    this.showInfo = false,
  });

  SettingConfig copyBut({
    bool newLightTheme,
    ScrollMode newScrollMode,
    bool newPerformanceOverlay,
    bool newShowInfo,
  }) =>
      SettingConfig(
        lightTheme: newLightTheme ?? lightTheme,
        scrollMode: newScrollMode ?? scrollMode,
        performanceOverlay: newPerformanceOverlay ?? performanceOverlay,
        showInfo: newShowInfo ?? showInfo,
      );

  final ScrollMode scrollMode;
  final bool lightTheme;
  final bool performanceOverlay;
  final bool showInfo;
}

class SettingDrawer extends StatelessWidget {
  const SettingDrawer({Key key}) : super(key: key);

  static const double slowTimeDilation = 5.0;
  static const double normalTimeDilation = 1.0;

  SettingConfig _config(BuildContext context) =>
      ModelBinding.of<SettingConfig>(context);

  void _changeTheme(BuildContext context, bool value) {
    ModelBinding.update<SettingConfig>(
        context, _config(context).copyBut(newLightTheme: value));
  }

  void _changeScrollMode(BuildContext context, ScrollMode value) {
    ModelBinding.update<SettingConfig>(
        context, _config(context).copyBut(newScrollMode: value));
  }

  void _toggleAnimationSpeed(BuildContext context) {
    timeDilation = timeDilation == normalTimeDilation
        ? slowTimeDilation
        : normalTimeDilation;
    // Effectively rebuild the drawer
    ModelBinding.update<SettingConfig>(context, _config(context).copyBut());
  }

  void _togglePerformanceOverlay(BuildContext context) {
    SettingConfig currentConfig = _config(context);
    ModelBinding.update<SettingConfig>(context,currentConfig.copyBut(
        newPerformanceOverlay: !currentConfig.performanceOverlay));
  }

  void _toggleInfoBar(BuildContext context) {
    SettingConfig currentConfig = _config(context);
    ModelBinding.update<SettingConfig>(context,currentConfig.copyBut(
        newShowInfo: !currentConfig.showInfo));
  }

  @override
  Widget build(BuildContext context) {
    SettingConfig config = _config(context);
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
              _changeScrollMode(
                  context,
                  config.scrollMode == ScrollMode.complex
                      ? ScrollMode.tile
                      : ScrollMode.complex);
              // Navigator.pop(context);
            },
            trailing: Text(
                config.scrollMode == ScrollMode.complex ? 'Tile' : 'Complex'),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_5),
            title: const Text('Light'),
            onTap: () {
              if (!config.lightTheme)
                _changeTheme(context, true);
            },
            selected: config.lightTheme,
            trailing: Radio<bool>(
              value: true,
              groupValue: config.lightTheme,
              onChanged: (bool value) {
                if (config.lightTheme != value)
                  _changeTheme(context, value);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_7),
            title: const Text('Dark'),
            onTap: () {
              if (config.lightTheme)
                _changeTheme(context, false);
            },
            selected: !config.lightTheme,
            trailing: Radio<bool>(
              value: false,
              groupValue: config.lightTheme,
              onChanged: (bool value) {
                if (config.lightTheme != value)
                  _changeTheme(context, value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.hourglass_empty),
            title: const Text('Animate Slowly'),
            selected: timeDilation == slowTimeDilation,
            onTap: () {
              _toggleAnimationSpeed(context);
            },
            trailing: Checkbox(
              value: timeDilation == slowTimeDilation,
              onChanged: (bool value) {
                _toggleAnimationSpeed(context);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Performance Overlay'),
            selected: config.performanceOverlay,
            onTap: () {
              _togglePerformanceOverlay(context);
            },
            trailing: Checkbox(
              value: config.performanceOverlay,
              onChanged: (bool value) {
                _togglePerformanceOverlay(context);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.equalizer),
            title: const Text('Show Scrolling Info'),
            selected: config.showInfo,
            onTap: () {
              _toggleInfoBar(context);
            },
            trailing: Checkbox(
              value: config.showInfo,
              onChanged: (bool value) {
                _toggleInfoBar(context);
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
