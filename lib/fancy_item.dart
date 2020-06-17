// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'icon_bar.dart';
import 'top_bar_menu.dart';

class FancyImageItem extends StatelessWidget {
  const FancyImageItem(this.index, {Key key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        UserHeader('Ali Connors $index'),
        ItemDescription(),
        ItemImageBox(),
        InfoBar(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(),
        ),
        IconBar(),
        FatDivider(),
      ],
    );
  }
}

class FancyGalleryItem extends StatelessWidget {
  const FancyGalleryItem(this.index, {Key key}) : super(key: key);

  final int index;
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        const UserHeader('Ali Connors'),
        ItemGalleryBox(index),
        InfoBar(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(),
        ),
        IconBar(),
        FatDivider(),
      ],
    );
  }
}

class InfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const MiniIconWithText(Icons.thumb_up, '42'),
          Text('3 Comments', style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }
}

class MiniIconWithText extends StatelessWidget {
  const MiniIconWithText(this.icon, this.title);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: 16.0,
            height: 16.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 12.0),
          ),
        ),
        Text(title, style: Theme.of(context).textTheme.caption),
      ],
    );
  }
}

class FatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.0,
      color: Theme.of(context).dividerColor,
    );
  }
}

class UserHeader extends StatelessWidget {
  const UserHeader(this.userName);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Image(
              image: AssetImage(
                  'packages/flutter_gallery_assets/people/square/ali.png'),
              width: 32.0,
              height: 32.0,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      children: <TextSpan>[
                        TextSpan(
                            text: userName,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' shared a new '),
                        const TextSpan(
                            text: 'photo',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )),
                Row(
                  children: <Widget>[
                    Text('Yesterday at 11:55 • ',
                        style: Theme.of(context).textTheme.caption),
                    Icon(Icons.people,
                        size: 16.0,
                        color: Theme.of(context).textTheme.caption.color),
                  ],
                ),
              ],
            ),
          ),
          TopBarMenu(),
        ],
      ),
    );
  }
}

class ItemDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
    );
  }
}

class ItemImageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                const SizedBox(
                  height: 230.0,
                  child: Image(
                    image: AssetImage(
                      'packages/flutter_gallery_assets/places/india_chettinad_silk_maker.png',
                    ),
                  ),
                ),
                Theme(
                  data: ThemeData.dark(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print('Pressed edit button');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.zoom_in),
                        onPressed: () {
                          print('Pressed zoom button');
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  left: 4.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(text: 'Photo by '),
                          TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            text: 'Chris Godley',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Artisans of Southern India',
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('Silk Spinners',
                      style: Theme.of(context).textTheme.bodyText2),
                  Text('Sivaganga, Tamil Nadu',
                      style: Theme.of(context).textTheme.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemGalleryBox extends StatelessWidget {
  const ItemGalleryBox(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final List<String> tabNames = <String>['A', 'B', 'C', 'D'];

    return SizedBox(
      height: 200.0,
      child: DefaultTabController(
        length: tabNames.length,
        child: Column(
          children: <Widget>[
            Expanded(child: TabBarView(
              children: tabNames.map<Widget>((String tabName) {
                return Container(
                  key: PageStorageKey<String>(tabName),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(child: Column(children: <Widget>[
                      Expanded(child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Center(child: Text(
                          tabName,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.white),
                        )),
                      )),
                      Row(children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {print('Pressed share');},
                        ),
                        IconButton(
                          icon: const Icon(Icons.event),
                          onPressed: () {print('Pressed event');},
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('This is item $tabName'),
                        )),
                      ]),
                    ])),
                  ),
                );
              }).toList(),
            )),
            Container(child: const TabPageSelector()),
          ],
        ),
      ),
    );
  }
}
