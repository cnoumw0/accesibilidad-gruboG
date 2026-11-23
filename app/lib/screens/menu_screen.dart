import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../data/menu_semanal.dart';
import '../models/menu.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/app_feedback.dart';

/// Menú de la semana: un menú distinto cada día, con los ingredientes que hay
/// que comprar. Los ingredientes se pasan a la lista con un botón.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _anadir(BuildContext context, List<DiaMenu> dias, String quien) {
    final (nuevos, existentes) = AppState.instance.anadirMenu(dias);
    final String mensaje;
    if (nuevos == 0) {
      mensaje = 'Los ingredientes $quien ya estaban en la lista.';
    } else if (existentes == 0) {
      mensaje = 'Se añadieron $nuevos productos $quien a la lista.';
    } else {
      mensaje =
          'Se añadieron $nuevos productos $quien a la lista. '
          '${existentes == 1 ? '1 ya estaba' : '$existentes ya estaban'}.';
    }
    AppFeedback.mostrarEnLista(context, mensaje);
    context.go('/lista');
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Menú de la semana')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Un menú distinto cada día. Al añadirlo a la lista se calcula '
            'cuánto comprar: por ejemplo, 1 kg de lentejas da para cuatro días.',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _anadir(context, MenuSemanal.dias, 'de la semana'),
            icon: const Icon(Icons.shopping_basket_outlined),
            label: const Text('Añadir toda la semana a la lista'),
          ),
          const SizedBox(height: 8),
          for (final dia in MenuSemanal.dias)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        dia.dia,
                        style: tema.titleLarge?.copyWith(
                          color: AppColors.verdeElist,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _Comida(titulo: 'Comida', plato: dia.comida),
                    const SizedBox(height: 8),
                    _Comida(titulo: 'Cena', plato: dia.cena),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () => _anadir(
                        context,
                        [dia],
                        'del ${dia.dia.toLowerCase()}',
                      ),
                      child: Text(
                        'Añadir ingredientes del ${dia.dia.toLowerCase()}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Comida extends StatelessWidget {
  const _Comida({required this.titulo, required this.plato});

  final String titulo;
  final Plato plato;

  @override
  Widget build(BuildContext context) {
    final ingredientes = plato.ingredientes
        .map((i) => i.nombre.toLowerCase())
        .join(', ');
    return Semantics(
      container: true,
      label: '$titulo: ${plato.nombre}. Ingredientes: $ingredientes.',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$titulo: ${plato.nombre}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text('Ingredientes: $ingredientes'),
          ],
        ),
      ),
    );
  }
}
