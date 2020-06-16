// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'model_binding.dart';
import 'setting_drawer.dart';
import 'bottom_bar.dart';
import 'top_bar_menu.dart';
import 'fancy_item.dart';
import 'icon_bar.dart';
import 'info_monitor.dart';

void main() {
  runApp(ComplexLayoutApp());
}

class ComplexLayoutApp extends StatelessWidget {
  final SettingDrawer drawer = SettingDrawer();
  Widget complexLayout(BuildContext context) {
    return Scaffold(
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
            child: ListView.builder(
              // this key is used by the driver test
              key: const Key('complex-scroll'),
              itemBuilder: (BuildContext context, int index) {
                if (index % 2 == 0)
                  return FancyImageItem(index, key: PageStorageKey<int>(index));
                else
                  return FancyGalleryItem(index,
                      key: PageStorageKey<int>(index));
              },
            ),
          ),
          BottomBar(),
        ],
      ),
      drawer: drawer,
    );
  }

  Widget tileScrollLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tile Scrolling Layout')),
      body: ListView.builder(
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
      ),
      drawer: drawer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModelBinding<SettingConfig>(
      initialModel: SettingConfig(),
      child: Builder(
        builder: (BuildContext context) {
          SettingConfig config = ModelBinding.of<SettingConfig>(context);
          bool lightTheme = config.lightTheme;
          ScrollMode scrollMode = config.scrollMode;
          bool performanceOverlay = config.performanceOverlay;
          bool showInfo = config.showInfo;
          Widget home = scrollMode == ScrollMode.complex
              ? complexLayout(context)
              : tileScrollLayout(context);
          Widget result = MaterialApp(
            showPerformanceOverlay: performanceOverlay,
            theme: lightTheme ? ThemeData.light() : ThemeData.dark(),
            title: 'Advanced Layout',
            home: home,
          );
          if (showInfo) {
            result = Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  result,
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: InfoMonitor('info'),
                  ),
                ],
              ),
            );
          }
          return result;
        },
      ),
    );
  }
}
