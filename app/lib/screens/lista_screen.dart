import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/producto.dart';
import '../state/app_state.dart';
import '../utils/app_feedback.dart';
import '../widgets/producto_tile.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

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
          final comprados = appState.productos
              .where((item) => item.comprado)
              .toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (appState.puedeDeshacer) ...[
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1F8),
                      borderRadius: BorderRadius.circular(8),
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
                            AppFeedback.show(
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
              _SeccionProductos(
                titulo: 'Pendientes',
                productos: pendientes,
                onCambiarEstado: (item) {
                  appState.cambiarEstado(item.id);
                  AppFeedback.show(
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
                  AppFeedback.show(
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
        Text(titulo, style: Theme.of(context).textTheme.titleLarge),
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
          for (final item in productos)
            ProductoTile(
              producto: item,
              onCambiarEstado: () => onCambiarEstado(item),
              onEditar: () => onEditar(item),
            ),
      ],
    );
  }
}
