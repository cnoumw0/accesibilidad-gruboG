import 'package:material_ui/material_ui.dart';

import '../models/producto.dart';

class ProductoTile extends StatelessWidget {
  const ProductoTile({
    required this.producto,
    required this.onCambiarEstado,
    required this.onEditar,
    super.key,
  });

  final Producto producto;
  final VoidCallback onCambiarEstado;
  final VoidCallback onEditar;

  @override
  Widget build(BuildContext context) {
    final estado = producto.estado;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF65758B)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              container: true,
              label:
                  '${producto.nombre}, ${producto.cantidad} '
                  '${producto.cantidad == 1 ? 'unidad' : 'unidades'}, $estado',
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${producto.cantidad} '
                      '${producto.cantidad == 1 ? 'unidad' : 'unidades'}',
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      avatar: Icon(
                        producto.comprado
                            ? Icons.check_circle_outline
                            : Icons.pending_outlined,
                        size: 18,
                        color: producto.comprado
                            ? const Color(0xFF12665B)
                            : const Color(0xFF704800),
                      ),
                      label: Text(estado),
                      backgroundColor: producto.comprado
                          ? const Color(0xFFE8F3F0)
                          : const Color(0xFFFFF4D6),
                      side: BorderSide(
                        color: producto.comprado
                            ? const Color(0xFF12665B)
                            : const Color(0xFF704800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            FilledButton.tonal(
              onPressed: onCambiarEstado,
              child: Text(
                'Marcar ${producto.nombre} como '
                '${producto.comprado ? 'pendiente' : 'comprado'}',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onEditar,
              child: Text('Editar o eliminar ${producto.nombre}'),
            ),
          ],
        ),
      ),
    );
  }
}
