import 'categoria.dart';

/// Ingrediente de un plato. Se compra por formato (por ejemplo, un paquete de
/// 1 kg) y un formato rinde para varios días: 1 kg de lentejas da para cuatro.
class Ingrediente {
  const Ingrediente(this.nombre, this.categoria, this.formato, this.rindeDias);

  final String nombre;
  final Categoria categoria;

  /// Formato de compra, como se ve en el súper.
  final String formato;

  /// Días de menú para los que llega un formato.
  final int rindeDias;

  String get nombreCompleto => '$nombre ($formato)';
}

class Plato {
  const Plato(this.nombre, this.ingredientes);

  final String nombre;
  final List<Ingrediente> ingredientes;
}

class DiaMenu {
  const DiaMenu(this.dia, this.comida, this.cena);

  final String dia;
  final Plato comida;
  final Plato cena;

  Iterable<Ingrediente> get ingredientes sync* {
    yield* comida.ingredientes;
    yield* cena.ingredientes;
  }
}

/// Una línea de la compra: cuántos formatos hacen falta y para qué días.
class LineaCompra {
  const LineaCompra(this.ingrediente, this.paquetes, this.dias);

  final Ingrediente ingrediente;
  final int paquetes;
  final List<String> dias;
}
