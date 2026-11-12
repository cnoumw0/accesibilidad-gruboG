class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    this.comprado = false,
    this.quienLoCompro,
  });

  final String id;
  final String nombre;
  final int cantidad;
  final bool comprado;
  final String? quienLoCompro;

  Producto copyWith({
    String? nombre,
    int? cantidad,
    bool? comprado,
    String? quienLoCompro,
    bool limpiarComprador = false,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
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
