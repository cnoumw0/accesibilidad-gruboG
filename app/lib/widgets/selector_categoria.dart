import 'package:flutter/widgets.dart' show Key;
import 'package:material_ui/material_ui.dart';

import '../models/categoria.dart';
import '../theme/app_theme.dart';

/// Desplegable de categoría con las sugerencias de esa sección debajo.
/// Tocar una sugerencia rellena el nombre; también se puede escribir otro.
class SelectorCategoria extends StatelessWidget {
  const SelectorCategoria({
    required this.categoria,
    required this.onCategoria,
    required this.onSugerencia,
    super.key,
  });

  final Categoria categoria;
  final ValueChanged<Categoria> onCategoria;
  final ValueChanged<String> onSugerencia;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<Categoria>(
          key: const Key('productCategoryField'),
          initialValue: categoria,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Categoría (sección del supermercado)',
          ),
          items: [
            for (final c in Categoria.values)
              DropdownMenuItem(
                value: c,
                child: Row(
                  children: [
                    Icon(c.icono, color: AppColors.verdeElist),
                    const SizedBox(width: 12),
                    Expanded(child: Text(c.etiqueta)),
                  ],
                ),
              ),
          ],
          onChanged: (value) {
            if (value != null) onCategoria(value);
          },
        ),
        if (categoria.sugerencias.isNotEmpty) ...[
          const SizedBox(height: 12),
          Semantics(
            header: true,
            child: Text(
              'Sugerencias de ${categoria.etiqueta}. '
              'Toca una o escribe el nombre abajo.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final nombre in categoria.sugerencias)
                ActionChip(
                  label: Text(nombre),
                  onPressed: () => onSugerencia(nombre),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
