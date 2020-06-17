// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'bottom_bar.dart';
import 'fancy_item.dart';
import 'icon_bar.dart';
import 'info_monitor.dart';
import 'model_binding.dart';
import 'setting_drawer.dart';
import 'top_bar_menu.dart';

void main() {
  runApp(ComplexLayoutApp());
}

class ComplexLayoutApp extends StatefulWidget {
  @override
  _ComplexLayoutAppState createState() => _ComplexLayoutAppState();
}

class _ComplexLayoutAppState extends State<ComplexLayoutApp> {
  _ComplexLayoutAppState()
      : pointerY = <double>[],
        pointerTimestamp = <double>[],
        scrollerY = <double>[],
        frameTimestamp = <double>[],
        _scrollSummary = 'Waiting...';
  final SettingDrawer drawer = const SettingDrawer();
  List<double> pointerY;
  List<double> pointerTimestamp;
  List<double> scrollerY;
  List<double> frameTimestamp;
  ListView scroller;
  String _scrollSummary;

  String get scrollSummary => _scrollSummary;
  void _updateSummary() {
    setState(() {
      _scrollSummary = pointerY.toString();
    });
  }

  void _scrollStart(PointerEvent details) {
    pointerY.clear();
    pointerTimestamp.clear();
    scrollerY.clear();
    frameTimestamp.clear();
    _scrolling(details);
    setState(() {
      _scrollSummary = 'Waiting...';
    });
  }

  void _scrollEnd(PointerEvent details) {
    _scrolling(details);
    _updateSummary();
  }

  void _scrolling(PointerEvent details) {
    pointerY.add(details.position.dy);
    pointerTimestamp.add(details.timeStamp.inMicroseconds / 1000.0);
  }

  ListView _complexList(BuildContext context) {
    return ListView.builder(
      // this key is used by the driver test
      key: const Key('complex-scroll'),
      itemBuilder: (BuildContext context, int index) {
        if (index % 2 == 0)
          return FancyImageItem(index, key: PageStorageKey<int>(index));
        else
          return FancyGalleryItem(index, key: PageStorageKey<int>(index));
      },
    );
  }

  ListView _tileList(BuildContext context) {
    return ListView.builder(
      key: const Key('tiles-scroll'),
      itemCount: 200,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Material(
            elevation: (index % 5 + 1).toDouble(),
            child: IconBar(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModelBinding<SettingConfig>(
      initialModel: const SettingConfig(),
      child: Builder(
        builder: (BuildContext context) {
          final SettingConfig config = ModelBinding.of<SettingConfig>(context);
          final bool lightTheme = config.lightTheme;
          final ScrollMode scrollMode = config.scrollMode;
          final bool performanceOverlay = config.performanceOverlay;
          final bool showInfo = config.showInfo;
          timeDilation = config.timeDilation;
          scroller = scrollMode == ScrollMode.complex
              ? _complexList(context)
              : _tileList(context);
          final Widget home = Scaffold(
            appBar: AppBar(
              title: const Text('Advanced Layout'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.create),
                  tooltip: 'Search',
                  onPressed: () {
                    print('Pressed search');
                  },
                ),
                TopBarMenu(),
              ],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Listener(
                    child: scroller,
                    onPointerDown: _scrollStart,
                    onPointerMove: _scrolling,
                    onPointerUp: _scrollEnd,
                  ),
                ),
                BottomBar(),
              ],
            ),
            drawer: drawer,
          );
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                MaterialApp(
                  showPerformanceOverlay: performanceOverlay,
                  theme: lightTheme ? ThemeData.light() : ThemeData.dark(),
                  title: 'Advanced Layout',
                  home: home,
                ),
                if (showInfo)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: InfoMonitor(scrollSummary),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
