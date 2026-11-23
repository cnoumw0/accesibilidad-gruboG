import 'categoria.dart';

class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    this.categoria = Categoria.otros,
    this.nota = '',
    this.supermercado = '',
    this.comprado = false,
    this.quienLoCompro,
  });

  final String id;
  final String nombre;
  final int cantidad;
  final Categoria categoria;

  /// Observaciones opcionales, por ejemplo una marca. Vacío si no hay.
  final String nota;

  /// Supermercado donde conviene comprarlo. Vacío si da igual.
  final String supermercado;
  final bool comprado;
  final String? quienLoCompro;

  Producto copyWith({
    String? nombre,
    int? cantidad,
    Categoria? categoria,
    String? nota,
    String? supermercado,
    bool? comprado,
    String? quienLoCompro,
    bool limpiarComprador = false,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      categoria: categoria ?? this.categoria,
      nota: nota ?? this.nota,
      supermercado: supermercado ?? this.supermercado,
      comprado: comprado ?? this.comprado,
      quienLoCompro: limpiarComprador
          ? null
          : quienLoCompro ?? this.quienLoCompro,
    );
  }

  String get estado => comprado
      ? 'Comprado${quienLoCompro == null ? '' : ' por $quienLoCompro'}'
      : 'Pendiente';
}

class ActividadItem {
  const ActividadItem(this.mensaje, this.tiempo);

  final String mensaje;
  final String tiempo;
}
