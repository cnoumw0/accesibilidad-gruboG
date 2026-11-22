// Pruebas de widget de eLIST.
//
// Comprueban que se puede entrar en la lista con el código familiar y que la
// pantalla Lista cumple las guías de accesibilidad que incluye Flutter
// (Accessibility Guideline API).

import 'package:flutter/foundation.dart' show Key;
import 'package:flutter_test/flutter_test.dart';

import 'package:elist_app/main.dart';
import 'package:elist_app/utils/app_feedback.dart';

void main() {
  testWidgets('permite entrar a la lista y la lista es accesible', (
    WidgetTester tester,
  ) async {
    final handle = tester.ensureSemantics();
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

    // Se quita el aviso inferior para comprobar solo la pantalla Lista.
    AppFeedback.messengerKey.currentState?.clearSnackBars();
    await tester.pumpAndSettle();

    // Objetivos táctiles de al menos 48 × 48 (Android).
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    // Todo control pulsable tiene nombre accesible.
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    // Contraste mínimo del texto (WCAG AA).
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    // «Comprados» queda debajo de la lista y ListView solo construye lo
    // visible, así que primero se desplaza hasta que aparece.
    await tester.scrollUntilVisible(find.text('Comprados'), 300);
    expect(find.text('Comprados'), findsOneWidget);
    handle.dispose();
  });
}
