// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

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
        frameTimestamp = <double>[];
  final SettingDrawer drawer = const SettingDrawer();
  List<double> pointerY;
  List<double> pointerTimestamp;
  List<double> scrollerY;
  List<double> frameTimestamp;
  ListView scroller;

  void _scrollStart(PointerEvent details) {
    pointerY.clear();
    pointerTimestamp.clear();
    scrollerY.clear();
    frameTimestamp.clear();
    _scrolling(details);
  }

  void _scrollEnd(PointerEvent details) {
    setState(() {
      _scrolling(details);
    });
  }

  void _scrolling(PointerEvent details) {
    pointerY.add(details.position.dy);
  }

  String get scrollSummary {
    if (pointerTimestamp.isEmpty)
      return 'info';
    return scrollSummary.toString();
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
                Expanded(child: scroller),
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
