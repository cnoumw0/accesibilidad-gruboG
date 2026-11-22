// Pruebas de widget de eLIST.
//
// Comprueban que se puede entrar en la lista con el código familiar y que la
// pantalla Lista cumple las guías de accesibilidad que incluye Flutter
// (Accessibility Guideline API).

import 'package:flutter/widgets.dart' show Key, Offset;
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
    // Deja que desaparezca el aviso de arriba de la lista.
    await tester.pump(const Duration(seconds: 9));

    expect(find.text('Familia Gómez'), findsOneWidget);
    expect(find.text('Leche'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);

    // Se quita el aviso inferior para comprobar solo la pantalla Lista.
    AppFeedback.messengerKey.currentState?.clearSnackBars();
    await tester.pumpAndSettle();

    await _comprobarGuias(tester);

    // «Comprados» queda debajo de la lista y ListView solo construye lo
    // visible, así que primero se desplaza hasta que aparece.
    await tester.scrollUntilVisible(find.text('Comprados'), 300);
    expect(find.text('Comprados'), findsOneWidget);

    // Pantalla Añadir producto: mismas guías en sus tres estados.
    // Se vuelve arriba del todo para que el botón no quede bajo la barra.
    await tester.drag(find.text('Comprados'), const Offset(0, 2000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Añadir producto'));
    await tester.pumpAndSettle();
    await _comprobarGuias(tester);

    // Estado de error: nombre vacío.
    await tester.tap(find.text('Añadir a la lista'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Falta el nombre del producto. Escríbelo para añadirlo a la lista.',
      ),
      findsOneWidget,
    );
    await _comprobarGuias(tester);

    // Estado de aviso: el producto ya existe.
    await tester.enterText(find.byKey(const Key('productNameField')), 'leche');
    await tester.tap(find.text('Añadir a la lista'));
    await tester.pumpAndSettle();
    expect(find.text('Sumar cantidad al existente'), findsOneWidget);
    await _comprobarGuias(tester);
    handle.dispose();
  });
}

/// Guías de accesibilidad de Flutter que debe cumplir cada pantalla.
Future<void> _comprobarGuias(WidgetTester tester) async {
  // Objetivos táctiles de al menos 48 × 48 (Android).
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  // Todo control pulsable tiene nombre accesible.
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  // Contraste mínimo del texto (WCAG AA).
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}
