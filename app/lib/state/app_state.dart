import 'package:flutter/foundation.dart';

import '../models/categoria.dart';
import '../models/habitual.dart';
import '../models/menu.dart';
import '../models/producto.dart';
import '../data/menu_semanal.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  static const codigoFamilia = 'FAMILIA24';
  String familyName = 'Familia Gómez';
  bool sesionIniciada = false;
  int _nextId = 5;

  List<Producto> _productos = _productosIniciales();
  List<Producto>? _snapshotDeshacer;
  List<Habitual> _habituales = _habitualesIniciales();

  final List<ActividadItem> _actividad = [
    const ActividadItem('Ana añadió Leche', 'Hace 2 minutos'),
    const ActividadItem('Luis marcó Pan como comprado', 'Hace 10 minutos'),
    const ActividadItem('Ana eliminó Yogur', 'Hace 25 minutos'),
  ];

  List<Producto> get productos => List.unmodifiable(_productos);
  List<ActividadItem> get actividad => List.unmodifiable(_actividad);
  bool get puedeDeshacer => _snapshotDeshacer != null;

  /// Productos de uso frecuente, con el día de la última compra. Los datos de
  /// ejemplo hacen que el café y el aceite estén «atrasados».
  static List<Habitual> _habitualesIniciales() {
    final ahora = DateTime.now();
    return [
      Habitual(
        nombre: 'Leche',
        categoria: Categoria.lacteos,
        cadaDias: 7,
        ultimaCompra: ahora.subtract(const Duration(days: 9)),
      ),
      Habitual(
        nombre: 'Café',
        categoria: Categoria.bebidas,
        cadaDias: 21,
        ultimaCompra: ahora.subtract(const Duration(days: 25)),
      ),
      Habitual(
        nombre: 'Huevos',
        categoria: Categoria.proteinas,
        cadaDias: 14,
        ultimaCompra: ahora.subtract(const Duration(days: 3)),
      ),
      Habitual(
        nombre: 'Aceite',
        categoria: Categoria.despensa,
        cadaDias: 30,
        ultimaCompra: ahora.subtract(const Duration(days: 40)),
      ),
    ];
  }

  /// Habituales que hace tiempo que no se compran y que no están ya
  /// pendientes en la lista.
  List<Habitual> get recordatorios {
    final ahora = DateTime.now();
    return [
      for (final h in _habituales)
        if (h.diasDesdeUltimaCompra(ahora) >= h.cadaDias &&
            (h.posponerHasta == null || ahora.isAfter(h.posponerHasta!)) &&
            !_estaPendiente(h.nombre))
          h,
    ];
  }

  bool _estaPendiente(String nombre) {
    final existente = buscarDuplicado(nombre);
    return existente != null && !existente.comprado;
  }

  Habitual? _habitualDe(String nombre) {
    final normalizado = normalizar(nombre);
    for (final h in _habituales) {
      if (normalizar(h.nombre) == normalizado) return h;
    }
    return null;
  }

  /// Pasa un habitual a la lista (o lo vuelve a poner como pendiente).
  void anadirHabitual(Habitual habitual) {
    _snapshotDeshacer = null;
    final existente = buscarDuplicado(habitual.nombre);
    if (existente == null) {
      _productos.add(
        Producto(
          id: '${_nextId++}',
          nombre: habitual.nombre,
          cantidad: 1,
          categoria: habitual.categoria,
        ),
      );
    } else if (existente.comprado) {
      _reemplazar(existente.copyWith(comprado: false, limpiarComprador: true));
    }
    _registrar('Tú añadiste ${habitual.nombre} desde un recordatorio');
    notifyListeners();
  }

  /// «Ahora no»: no se vuelve a preguntar por este producto en tres días.
  void posponerHabitual(Habitual habitual) {
    habitual.posponerHasta = DateTime.now().add(const Duration(days: 3));
    notifyListeners();
  }

  static List<Producto> _productosIniciales() => [
    const Producto(
      id: '1',
      nombre: 'Leche',
      cantidad: 2,
      categoria: Categoria.lacteos,
    ),
    const Producto(
      id: '2',
      nombre: 'Pan',
      cantidad: 1,
      categoria: Categoria.panaderia,
    ),
    const Producto(
      id: '3',
      nombre: 'Huevos',
      cantidad: 6,
      categoria: Categoria.proteinas,
    ),
    const Producto(
      id: '4',
      nombre: 'Arroz',
      cantidad: 1,
      categoria: Categoria.despensa,
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
    _habituales = _habitualesIniciales();
    _snapshotDeshacer = null;
    _registrar('Has entrado en $familyName');
    notifyListeners();
  }

  void crearGrupo(String nombre) {
    familyName = nombre.trim();
    sesionIniciada = true;
    _productos = [];
    _habituales = [];
    _actividad.clear();
    _snapshotDeshacer = null;
    notifyListeners();
  }

  void cerrarSesion() {
    sesionIniciada = false;
    _productos = _productosIniciales();
    _habituales = _habitualesIniciales();
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

  void anadir(
    String nombre,
    int cantidad,
    Categoria categoria, [
    String nota = '',
    String supermercado = '',
  ]) {
    _snapshotDeshacer = null;
    final existente = buscarDuplicado(nombre);
    if (existente == null) {
      _productos.add(
        Producto(
          id: '${_nextId++}',
          nombre: nombre.trim(),
          cantidad: cantidad,
          categoria: categoria,
          nota: nota.trim(),
          supermercado: supermercado.trim(),
        ),
      );
      _registrar('Tú añadiste ${nombre.trim()}');
    } else {
      _reemplazar(
        existente.copyWith(
          cantidad: existente.cantidad + cantidad,
          nota: nota.trim().isEmpty ? null : nota.trim(),
          supermercado: supermercado.trim().isEmpty
              ? null
              : supermercado.trim(),
        ),
      );
      _registrar('Tú sumaste $cantidad a ${existente.nombre}');
    }
    notifyListeners();
  }

  void guardarEdicion(
    String id,
    String nombre,
    int cantidad,
    Categoria categoria,
    String nota,
    String supermercado,
  ) {
    final item = producto(id);
    if (item == null) return;
    _snapshotDeshacer = null;
    _reemplazar(
      item.copyWith(
        nombre: nombre.trim(),
        cantidad: cantidad,
        categoria: categoria,
        nota: nota.trim(),
        supermercado: supermercado.trim(),
      ),
    );
    _registrar('Tú actualizaste ${nombre.trim()}');
    notifyListeners();
  }

  /// Pasa a la lista los ingredientes de los días elegidos. Devuelve cuántos
  /// productos se añadieron y cuántos ya estaban en la lista (esos no se
  /// repiten, para no duplicar la compra si se pulsa dos veces).
  (int, int) anadirMenu(List<DiaMenu> dias) {
    _snapshotDeshacer = null;
    var nuevos = 0;
    var existentes = 0;
    for (final linea in MenuSemanal.compra(dias)) {
      final ingrediente = linea.ingrediente;
      if (buscarDuplicado(ingrediente.nombreCompleto) != null) {
        existentes++;
        continue;
      }
      _productos.add(
        Producto(
          id: '${_nextId++}',
          nombre: ingrediente.nombreCompleto,
          cantidad: linea.paquetes,
          categoria: ingrediente.categoria,
          nota: 'Menú: ${linea.dias.join(', ')}',
        ),
      );
      nuevos++;
    }
    if (nuevos > 0) _registrar('Tú añadiste $nuevos productos desde el menú');
    notifyListeners();
    return (nuevos, existentes);
  }

  void cambiarEstado(String id) {
    final item = producto(id);
    if (item == null) return;
    _snapshotDeshacer = List.of(_productos);
    final nuevoEstado = !item.comprado;
    if (nuevoEstado) {
      // Comprarlo reinicia la cuenta de días del recordatorio.
      _habitualDe(item.nombre)
        ?..ultimaCompra = DateTime.now()
        ..posponerHasta = null;
    }
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
