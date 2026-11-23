// Prueba de la pantalla del menú semanal.
//
// Va en su propio archivo porque el enrutador de la app es único: así empieza
// siempre desde la pantalla de acceso.

import 'package:flutter/widgets.dart' show Key, Size;
import 'package:flutter_test/flutter_test.dart';

import 'package:elist_app/main.dart';
import 'package:elist_app/utils/app_feedback.dart';

void main() {
  testWidgets('el menú de la semana es accesible y añade a la lista', (
    WidgetTester tester,
  ) async {
    final handle = tester.ensureSemantics();
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const ElistApp());
    await tester.enterText(
      find.byKey(const Key('familyCodeField')),
      'FAMILIA24',
    );
    await tester.tap(find.text('Entrar en mi familia'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 9));
    AppFeedback.messengerKey.currentState?.clearSnackBars();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Menú de la semana'));
    await tester.pumpAndSettle();
    expect(find.text('Lunes'), findsOneWidget);
    await _comprobarGuias(tester);

    // Añade los ingredientes del lunes: vuelve a la lista con un aviso.
    await tester.tap(find.text('Añadir ingredientes del lunes'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    expect(find.textContaining('Se añadieron 6 productos del lunes'), findsOneWidget);
    await tester.pump(const Duration(seconds: 9));
    handle.dispose();
  });

}

/// Guías de accesibilidad de Flutter que debe cumplir la pantalla.
Future<void> _comprobarGuias(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}
