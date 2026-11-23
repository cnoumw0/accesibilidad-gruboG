// Pruebas del cálculo de la compra a partir del menú semanal.

import 'package:flutter_test/flutter_test.dart';

import 'package:elist_app/data/menu_semanal.dart';

void main() {
  test('1 kg de lentejas da para cuatro días: dos días usan un paquete', () {
    final lineas = MenuSemanal.compra(MenuSemanal.dias);
    final lentejas = lineas.firstWhere((l) => l.ingrediente.nombre == 'Lentejas');
    expect(lentejas.paquetes, 1);
    expect(lentejas.dias, ['lunes', 'jueves']);
  });

  test('un ingrediente que se usa más días que su formato necesita más paquetes', () {
    final lineas = MenuSemanal.compra(MenuSemanal.dias);
    final patatas = lineas.firstWhere((l) => l.ingrediente.nombre == 'Patatas');
    // Se usan 5 días y un formato de 2 kg rinde 4.
    expect(patatas.paquetes, 2);
  });

  test('un solo día pide un paquete de cada ingrediente', () {
    final lineas = MenuSemanal.compra([MenuSemanal.dias.first]);
    expect(lineas.every((l) => l.paquetes == 1), isTrue);
  });
}
