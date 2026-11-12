import 'package:flutter/foundation.dart';

import '../models/producto.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  static const codigoFamilia = 'FAMILIA24';
  String familyName = 'Familia Gómez';
  bool sesionIniciada = false;
  int _nextId = 5;

  List<Producto> _productos = _productosIniciales();
  List<Producto>? _snapshotDeshacer;

  final List<ActividadItem> _actividad = [
    const ActividadItem('Ana añadió Leche', 'Hace 2 minutos'),
    const ActividadItem('Luis marcó Pan como comprado', 'Hace 10 minutos'),
    const ActividadItem('Ana eliminó Yogur', 'Hace 25 minutos'),
  ];

  List<Producto> get productos => List.unmodifiable(_productos);
  List<ActividadItem> get actividad => List.unmodifiable(_actividad);
  bool get puedeDeshacer => _snapshotDeshacer != null;

  static List<Producto> _productosIniciales() => [
    const Producto(id: '1', nombre: 'Leche', cantidad: 2),
    const Producto(id: '2', nombre: 'Pan', cantidad: 1),
    const Producto(id: '3', nombre: 'Huevos', cantidad: 6),
    const Producto(
      id: '4',
      nombre: 'Arroz',
      cantidad: 1,
      comprado: true,
      quienLoCompro: 'Ana',
    ),
  ];

  Producto? producto(String id) {
    for (final item in _productos) {
      if (item.id == id) return item;
    }
    return null;
  }

  Producto? buscarDuplicado(String nombre) {
    final normalizado = normalizar(nombre);
    for (final item in _productos) {
      if (normalizar(item.nombre) == normalizado) return item;
    }
    return null;
  }

  static String normalizar(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp('[áàäâ]'), 'a')
      .replaceAll(RegExp('[éèëê]'), 'e')
      .replaceAll(RegExp('[íìïî]'), 'i')
      .replaceAll(RegExp('[óòöô]'), 'o')
      .replaceAll(RegExp('[úùüû]'), 'u');

  void entrar() {
    sesionIniciada = true;
    familyName = 'Familia Gómez';
    _productos = _productosIniciales();
    _snapshotDeshacer = null;
    _registrar('Has entrado en $familyName');
    notifyListeners();
  }

  void crearGrupo(String nombre) {
    familyName = nombre.trim();
    sesionIniciada = true;
    _productos = [];
    _actividad.clear();
    _snapshotDeshacer = null;
    notifyListeners();
  }

  void cerrarSesion() {
    sesionIniciada = false;
    _productos = _productosIniciales();
    _actividad
      ..clear()
      ..add(const ActividadItem('Ana añadió Leche', 'Hace 2 minutos'))
      ..add(
        const ActividadItem('Luis marcó Pan como comprado', 'Hace 10 minutos'),
      )
      ..add(const ActividadItem('Ana eliminó Yogur', 'Hace 25 minutos'));
    _snapshotDeshacer = null;
    notifyListeners();
  }

  void anadir(String nombre, int cantidad) {
    _snapshotDeshacer = null;
    final existente = buscarDuplicado(nombre);
    if (existente == null) {
      _productos.add(
        Producto(id: '${_nextId++}', nombre: nombre.trim(), cantidad: cantidad),
      );
      _registrar('Tú añadiste ${nombre.trim()}');
    } else {
      _reemplazar(existente.copyWith(cantidad: existente.cantidad + cantidad));
      _registrar('Tú sumaste $cantidad a ${existente.nombre}');
    }
    notifyListeners();
  }

  void guardarEdicion(String id, String nombre, int cantidad) {
    final item = producto(id);
    if (item == null) return;
    _snapshotDeshacer = null;
    _reemplazar(item.copyWith(nombre: nombre.trim(), cantidad: cantidad));
    _registrar('Tú actualizaste ${nombre.trim()}');
    notifyListeners();
  }

  void cambiarEstado(String id) {
    final item = producto(id);
    if (item == null) return;
    _snapshotDeshacer = List.of(_productos);
    final nuevoEstado = !item.comprado;
    _reemplazar(
      item.copyWith(
        comprado: nuevoEstado,
        quienLoCompro: nuevoEstado ? 'ti' : null,
        limpiarComprador: !nuevoEstado,
      ),
    );
    _registrar(
      'Tú marcaste ${item.nombre} como ${nuevoEstado ? 'comprado' : 'pendiente'}',
    );
    notifyListeners();
  }

  void eliminar(String id) {
    final item = producto(id);
    if (item == null) return;
    _snapshotDeshacer = List.of(_productos);
    _productos.removeWhere((producto) => producto.id == id);
    _registrar('Tú eliminaste ${item.nombre}');
    notifyListeners();
  }

  void deshacer() {
    final snapshot = _snapshotDeshacer;
    if (snapshot == null) return;
    _productos = List.of(snapshot);
    _snapshotDeshacer = null;
    _registrar('Acción deshecha. Se ha restaurado el estado anterior.');
    notifyListeners();
  }

  void _reemplazar(Producto actualizado) {
    final index = _productos.indexWhere((item) => item.id == actualizado.id);
    if (index >= 0) _productos[index] = actualizado;
  }

  void _registrar(String mensaje) {
    _actividad.insert(0, ActividadItem(mensaje, 'Ahora'));
  }
}
