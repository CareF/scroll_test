// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

enum ScrollMode { complex, tile }

@immutable
class SettingConfig {
  const SettingConfig({
    bool lightTheme = true,
    ScrollMode scrollMode = ScrollMode.complex,
    bool performanceOverlay = false,
    this.owner,
  })  : _lightTheme = lightTheme,
        _scrollMode = scrollMode,
        _performanceOverlay = performanceOverlay;

  SettingConfig copyBut({
    bool newLightTheme,
    ScrollMode newScrollMode,
    bool performanceOverlay,
  }) =>
      SettingConfig(
        lightTheme: newLightTheme ?? _lightTheme,
        scrollMode: newScrollMode ?? _scrollMode,
        performanceOverlay: performanceOverlay ?? _performanceOverlay,
        owner: owner,
      );

  final _GlobalSettingState owner;

  final ScrollMode _scrollMode;
  final bool _lightTheme;
  final bool _performanceOverlay;

  ScrollMode get scrollMode => _scrollMode;
  set scrollMode(ScrollMode value) {
    owner.updateConfig(copyBut(newScrollMode: value));
  }

  bool get lightTheme => _lightTheme;
  set lightTheme(bool value) {
    owner.updateConfig(copyBut(newLightTheme: value));
  }

  bool get performanceOverlay => _performanceOverlay;
  set performanceOverlay(bool value) {
    owner.updateConfig(copyBut(performanceOverlay: value));
  }
  void togglePerformanceOverlay() {
    performanceOverlay = !performanceOverlay;
  }

  bool get slowMode => timeDilation != 1.0;
  void toggleAnimationSpeed() {
    timeDilation = (timeDilation != 1.0) ? 1.0 : 5.0;
  }

  SettingConfig applyTo(_GlobalSettingState widget) => SettingConfig(
        lightTheme: _lightTheme,
        scrollMode: _scrollMode,
        owner: widget,
      );

  static SettingConfig of(BuildContext context) {
    _InheritedSetting scope =
        context.dependOnInheritedWidgetOfExactType<_InheritedSetting>();
    return scope.setting.config;
  }
}

class GlobalSetting extends StatefulWidget {
  GlobalSetting({
    Key key,
    this.child,
    SettingConfig config,
  })  : initConfig = config ?? SettingConfig(),
        super(key: key);

  final Widget child;
  final SettingConfig initConfig;

  @override
  _GlobalSettingState createState() => _GlobalSettingState();
}

class _GlobalSettingState extends State<GlobalSetting> {
  SettingConfig config;
  @override
  void initState() {
    super.initState();
    config = widget.initConfig.applyTo(this);
  }

  void updateConfig(SettingConfig newConfig) {
    setState(() {
      config = newConfig;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSetting(
      child: widget.child,
      setting: this,
    );
  }
}

class _InheritedSetting extends InheritedWidget {
  const _InheritedSetting(
      {Key key, @required Widget child, @required this.setting})
      : assert(child != null),
        super(key: key, child: child);

  final _GlobalSettingState setting;

  @override
  bool updateShouldNotify(_InheritedSetting old) => true;
}
