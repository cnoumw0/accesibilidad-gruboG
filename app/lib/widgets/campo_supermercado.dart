import 'package:flutter/widgets.dart' show Key;
import 'package:material_ui/material_ui.dart';

/// Campo opcional con el supermercado donde conviene comprar el producto, con
/// sugerencias que se pueden tocar. También se puede escribir otro nombre.
class CampoSupermercado extends StatelessWidget {
  const CampoSupermercado({required this.controller, super.key});

  final TextEditingController controller;

  static const sugerencias = [
    'Mercadona',
    'Lidl',
    'Carrefour',
    'Dia',
    'Alcampo',
    'Eroski',
    'Alimerka',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('productStoreField'),
          controller: controller,
          textInputAction: TextInputAction.next,
          maxLength: 40,
          decoration: const InputDecoration(
            labelText: 'Supermercado (opcional)',
            helperText: 'Dónde sale más económico comprarlo.',
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final nombre in sugerencias)
              ActionChip(
                label: Text(nombre),
                onPressed: () => controller.text = nombre,
              ),
          ],
        ),
      ],
    );
  }
}
