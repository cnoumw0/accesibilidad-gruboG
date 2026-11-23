import 'categoria.dart';

/// Producto que la familia compra a menudo (leche, café…). Si pasa más tiempo
/// del habitual desde la última compra, la lista pregunta si se quiere.
class Habitual {
  Habitual({
    required this.nombre,
    required this.categoria,
    required this.cadaDias,
    required this.ultimaCompra,
    this.posponerHasta,
  });

  final String nombre;
  final Categoria categoria;

  /// Cada cuántos días se suele comprar.
  final int cadaDias;

  DateTime ultimaCompra;

  /// Si la familia dijo «ahora no», no se vuelve a preguntar hasta esta fecha.
  DateTime? posponerHasta;

  int diasDesdeUltimaCompra(DateTime ahora) =>
      ahora.difference(ultimaCompra).inDays;
}
