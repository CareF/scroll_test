// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

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
        pointerTimestamp = <int>[],
        scrollerY = <double>[],
        frameTimestamp = <int>[],
        _scrollSummary = 'Waiting...' {
    ticker = Ticker(_updateFrameInfo);
    scroller = ScrollController();
  }
  final SettingDrawer drawer = const SettingDrawer();
  Ticker ticker;
  List<double> pointerY;
  List<int> pointerTimestamp;
  List<double> scrollerY;
  List<int> frameTimestamp;
  int _eventTimeOffset;
  ScrollController scroller;
  String _scrollSummary;
  
  void _updateFrameInfo(Duration elapsed) {
    frameTimestamp.add(elapsed.inMicroseconds);
    scrollerY.add(scroller.offset);
  }

  String get scrollSummary => _scrollSummary;
  void _updateSummary() {
    setState(() {
      _scrollSummary = pointerY.toString();
      _scrollSummary += '\n';
      _scrollSummary += pointerTimestamp.toString();
      _scrollSummary += '\n';
      _scrollSummary += scrollerY.toString();
      _scrollSummary += '\n';
      _scrollSummary += frameTimestamp.toString();
      _scrollSummary += '\n';
    });
  }

  void _clearRecord() {
    pointerY.clear();
    pointerTimestamp.clear();
    scrollerY.clear();
    frameTimestamp.clear();
  }

  void _scrollStart(PointerEvent details) {
    _clearRecord();
    _eventTimeOffset = details.timeStamp.inMicroseconds;
    ticker.start();
    _scrolling(details);
    setState(() {
      _scrollSummary = 'Waiting...';
    });
  }

  void _scrollEnd(PointerEvent details) {
    _scrolling(details);
    ticker.stop();
    _updateSummary();
  }

  void _scrolling(PointerEvent details) {
    final double positionY = details.position.dy;
    final int timeStamp = details.timeStamp.inMicroseconds - _eventTimeOffset;
    pointerY.add(positionY);
    pointerTimestamp.add(timeStamp);
    Timeline.instantSync(
      'ScrollingEvent',
      arguments: <String, dynamic>{'timestamp': timeStamp, 'position': positionY},
    );
  }

  ListView _complexList(BuildContext context) {
    return ListView.builder(
      // this key is used by the driver test
      key: const Key('complex-scroll'),
      controller: scroller,
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
      controller: scroller,
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
    _clearRecord();
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
          final ListView scrollableList = scrollMode == ScrollMode.complex
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
                  child: showInfo
                      ? Listener(
                          child: scrollableList,
                          onPointerDown: _scrollStart,
                          onPointerMove: _scrolling,
                          onPointerUp: _scrollEnd,
                        )
                      : scrollableList,
                ),
                BottomBar(),
              ],
            ),
            drawer: drawer,
          );
          Widget theApp = MaterialApp(
            showPerformanceOverlay: performanceOverlay,
            theme: lightTheme ? ThemeData.light() : ThemeData.dark(),
            title: 'Advanced Layout',
            home: home,
          );
          // if (showInfo) {
          // This if will results in destroying the route. 
            theApp = Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  theApp,
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
          // }
          return theApp;
        },
      ),
    );
  }
}
