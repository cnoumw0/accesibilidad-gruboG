// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart' show Key;
import 'package:flutter_test/flutter_test.dart';

import 'package:elist_app/main.dart';

void main() {
  testWidgets('permite entrar a la lista con el código familiar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ElistApp());
    await tester.enterText(
      find.byKey(const Key('familyCodeField')),
      'FAMILIA24',
    );
    await tester.tap(find.text('Entrar en mi familia'));
    await tester.pumpAndSettle();

    expect(find.text('Familia Gómez'), findsOneWidget);
    expect(find.text('Leche'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);

    // «Comprados» queda debajo de la lista y ListView solo construye lo
    // visible, así que primero se desplaza hasta que aparece.
    await tester.scrollUntilVisible(find.text('Comprados'), 300);
    expect(find.text('Comprados'), findsOneWidget);
  });
}
