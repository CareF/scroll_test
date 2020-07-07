import 'dart:developer' as developer;
import 'dart:io';
import 'dart:isolate' as isolate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e2e/e2e.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

import 'package:complex_layout/main.dart' as app;

Future<void> main() async {
//  VmService vmService;
//  final developer.ServiceProtocolInfo info = await developer.Service.getInfo();
//
//  if (info.serverUri == null) {
//    print('This test _must_ be run with --enable-vmservice.');
//    exit(-1);
//  }
//
//  vmService = await vmServiceConnectUri('ws://localhost:${info.serverUri.port}${info.serverUri.path}ws');
//  await vmService.setVMTimelineFlags(<String>['Dart']);

  // E2EWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test simple scrolling', (WidgetTester tester) async {
    // app.main();
    await tester.pumpWidget(app.ComplexLayoutApp());
    await tester.pumpAndSettle();
    // await tester.pumpWidget(app.ComplexLayoutApp());
    print('Waiting for 5s.');
    // await Future<void>.delayed(const Duration(seconds: 5));
    print('Testing start.');

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('auto-scroll')));
    await tester.tap(find.byKey(const ValueKey<String>('info-switcher')));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const ValueKey<String>('complex-scroll')),
      const Offset(0.0, -700),
    );
    await tester.pumpAndSettle();
    // await Future<void>.delayed(const Duration(seconds: 2));
//    final Timeline timeline = await vmService.getVMTimeline();
//    print(timeline.toString());
  });
}