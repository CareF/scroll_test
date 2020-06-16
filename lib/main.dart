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

void main() {
  runApp(ComplexLayoutApp());
}

class ComplexLayoutApp extends StatelessWidget {
  Widget _tileScrollLayout(BuildContext context) {
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
      drawer: const SettingDrawer(),
    );
  }

  Widget _complexLayout(BuildContext context) {
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
      drawer: const SettingDrawer(),
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
          return MaterialApp(
            showPerformanceOverlay: performanceOverlay,
            theme: lightTheme ? ThemeData.light() : ThemeData.dark(),
            title: 'Advanced Layout',
            home: scrollMode == ScrollMode.complex
                ? const ComplexLayout()
                : const TileScrollLayout(),
//                  ? _complexLayout(context)
//                  : _tileScrollLayout(context),
          );
        },
      ),
    );
  }
}

class TileScrollLayout extends StatelessWidget {
  const TileScrollLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      drawer: const SettingDrawer(),
    );
  }
}

class ComplexLayout extends StatefulWidget {
  const ComplexLayout({Key key}) : super(key: key);

  @override
  ComplexLayoutState createState() => ComplexLayoutState();

  static ComplexLayoutState of(BuildContext context) =>
      context.findAncestorStateOfType<ComplexLayoutState>();
}

class ComplexLayoutState extends State<ComplexLayout> {
  @override
  Widget build(BuildContext context) {
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
      drawer: const SettingDrawer(),
    );
  }
}
