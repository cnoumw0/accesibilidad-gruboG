import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/categoria.dart';
import '../models/habitual.dart';
import '../models/producto.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/app_feedback.dart';
import '../widgets/producto_tile.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  /// Aviso visible en la parte de arriba de la lista. Es el primer elemento de
  /// la pantalla, así que TalkBack lo lee al llegar, sin depender de ningún
  /// anuncio con temporizador. Vacío si no hay aviso.
  String _textoAviso = '';
  Timer? _temporizadorAviso;

  /// Espera antes de mostrar el aviso: al cambiar de pantalla o de foco,
  /// TalkBack anuncia primero la pantalla y corta lo que se esté diciendo.
  static const _esperaAviso = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    AppFeedback.avisoLista.addListener(_alLlegarAviso);
    // Aviso que llegó antes de que esta pantalla existiera (al entrar desde
    // Añadir, Editar o Acceso).
    _alLlegarAviso();
  }

  @override
  void dispose() {
    AppFeedback.avisoLista.removeListener(_alLlegarAviso);
    _temporizadorAviso?.cancel();
    super.dispose();
  }

  void _alLlegarAviso() {
    final aviso = AppFeedback.avisoLista.value;
    if (aviso == null) return;
    // Se consume el aviso para que no vuelva a mostrarse al reabrir la lista.
    AppFeedback.avisoLista.value = null;
    _temporizadorAviso?.cancel();
    if (_textoAviso.isNotEmpty) setState(() => _textoAviso = '');
    _temporizadorAviso = Timer(_esperaAviso, () {
      if (!mounted) return;
      setState(() => _textoAviso = aviso.texto);
      _temporizadorAviso = Timer(const Duration(seconds: 6), () {
        if (mounted) setState(() => _textoAviso = '');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: appState,
          builder: (context, _) => Text(appState.familyName),
        ),
        actions: [
          IconButton(
            tooltip: 'Menú de la semana',
            onPressed: () => context.push('/menu'),
            icon: const Icon(Icons.restaurant_menu),
          ),
          IconButton(
            tooltip: 'Actividad',
            onPressed: () => context.push('/actividad'),
            icon: const Icon(Icons.history),
          ),
          IconButton(
            tooltip: 'Mi familia',
            onPressed: () => context.push('/familia'),
            icon: const Icon(Icons.people_outline),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          final pendientes = appState.productos
              .where((item) => !item.comprado)
              .toList();
          // Como mucho dos avisos a la vez, para que la lista empiece pronto.
          final recordatorios = appState.recordatorios;
          final comprados = appState.productos
              .where((item) => item.comprado)
              .toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Aviso de lo último que se ha hecho. Región en directo con
              // texto visible: TalkBack lo lee al aparecer, también cuando el
              // foco se mueve al cambiar un producto de sección.
              if (_textoAviso.isNotEmpty) ...[
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1F8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF65758B)),
                    ),
                    child: Text(_textoAviso),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (appState.puedeDeshacer) ...[
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1F8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF65758B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Puedes deshacer la última acción.'),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            appState.deshacer();
                            AppFeedback.mostrarEnLista(
                              context,
                              'Acción deshecha. Se ha restaurado el estado anterior.',
                            );
                          },
                          icon: const Icon(Icons.undo),
                          label: const Text('Deshacer última acción'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              FilledButton.icon(
                onPressed: () => context.push('/anadir'),
                icon: const Icon(Icons.add),
                label: const Text('Añadir producto'),
              ),
              const SizedBox(height: 20),
              if (recordatorios.isNotEmpty) ...[
                Semantics(
                  header: true,
                  child: Text(
                    'Por si acaso',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                for (final habitual in recordatorios.take(2))
                  _Recordatorio(
                    habitual: habitual,
                    onAnadir: () {
                      appState.anadirHabitual(habitual);
                      AppFeedback.mostrarEnLista(
                        context,
                        '${habitual.nombre} añadido a la lista.',
                      );
                    },
                    onAhoraNo: () {
                      appState.posponerHabitual(habitual);
                      AppFeedback.mostrarEnLista(
                        context,
                        'Vale, te preguntaré por ${habitual.nombre} dentro de tres días.',
                      );
                    },
                  ),
                if (recordatorios.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Hay ${recordatorios.length - 2} recordatorios más. '
                      'Aparecerán cuando respondas a estos.',
                    ),
                  ),
                const SizedBox(height: 16),
              ],
              _SeccionProductos(
                titulo: 'Pendientes',
                productos: pendientes,
                onCambiarEstado: (item) {
                  appState.cambiarEstado(item.id);
                  AppFeedback.mostrarEnLista(
                    context,
                    '${item.nombre} marcado como comprado.',
                  );
                },
                onEditar: (item) => context.push('/editar/${item.id}'),
              ),
              const SizedBox(height: 16),
              _SeccionProductos(
                titulo: 'Comprados',
                productos: comprados,
                onCambiarEstado: (item) {
                  appState.cambiarEstado(item.id);
                  AppFeedback.mostrarEnLista(
                    context,
                    '${item.nombre} marcado como pendiente.',
                  );
                },
                onEditar: (item) => context.push('/editar/${item.id}'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SeccionProductos extends StatelessWidget {
  const _SeccionProductos({
    required this.titulo,
    required this.productos,
    required this.onCambiarEstado,
    required this.onEditar,
  });

  final String titulo;
  final List<Producto> productos;
  final ValueChanged<Producto> onCambiarEstado;
  final ValueChanged<Producto> onEditar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado semántico: permite saltar entre secciones con TalkBack.
        Semantics(
          header: true,
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 4),
        if (productos.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No hay productos',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          // Productos agrupados por sección del supermercado, en el orden en
          // que se recorre la tienda.
          for (final categoria in Categoria.values)
            if (productos.any((item) => item.categoria == categoria)) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 2, left: 4),
                child: Semantics(
                  header: true,
                  child: Row(
                    children: [
                      Icon(categoria.icono, color: AppColors.verdeElist),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          categoria.etiqueta,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.verdeElist,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              for (final item in productos.where(
                (item) => item.categoria == categoria,
              ))
                ProductoTile(
                  producto: item,
                  onCambiarEstado: () => onCambiarEstado(item),
                  onEditar: () => onEditar(item),
                ),
            ],
      ],
    );
  }
}

class _Recordatorio extends StatelessWidget {
  const _Recordatorio({
    required this.habitual,
    required this.onAnadir,
    required this.onAhoraNo,
  });

  final Habitual habitual;
  final VoidCallback onAnadir;
  final VoidCallback onAhoraNo;

  @override
  Widget build(BuildContext context) {
    final dias = habitual.diasDesdeUltimaCompra(DateTime.now());
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hace $dias días que no compras ${habitual.nombre}. '
              '¿Lo quieres en la lista?',
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: onAnadir,
              child: Text('Añadir ${habitual.nombre} a la lista'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onAhoraNo,
              child: Text('${habitual.nombre}, ahora no'),
            ),
          ],
        ),
      ),
    );
  }
}
