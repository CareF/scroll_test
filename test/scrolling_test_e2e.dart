import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e2e/e2e.dart';

import 'package:complex_layout/main.dart' as app;

Future<void> main() async {
  E2EWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test simple scrolling', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    // await tester.pumpWidget(app.ComplexLayoutApp());
    print('Waiting for 5s.');
    await Future<void>.delayed(const Duration(seconds: 5));
    print('Testing start.');

    await tester.tap(find.byTooltip('Open navigation menu'));
    // await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('auto-scroll')));
    await tester.tap(find.byKey(const ValueKey<String>('info-switcher')));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const ValueKey<String>('complex-scroll')),
      const Offset(0.0, -700),
    );
    await tester.pumpAndSettle();
    await Future<void>.delayed(const Duration(seconds: 2));
  });
}