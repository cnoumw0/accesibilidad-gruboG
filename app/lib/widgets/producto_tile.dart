import 'package:material_ui/material_ui.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';

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
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.bordeSuave),
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
                  '${producto.cantidad == 1 ? 'unidad' : 'unidades'}, $estado'
                  '${producto.nota.isEmpty ? '' : ', observaciones: ${producto.nota}'}'
                  '${producto.supermercado.isEmpty ? '' : ', supermercado: ${producto.supermercado}'}',
              // El texto visible ya está resumido en la etiqueta del contenedor;
              // se excluye para que TalkBack no lea el producto dos veces.
              child: ExcludeSemantics(
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
                    if (producto.nota.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('Observaciones: ${producto.nota}'),
                    ],
                    if (producto.supermercado.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('Supermercado: ${producto.supermercado}'),
                    ],
                    const SizedBox(height: 8),
                    Chip(
                      avatar: Icon(
                        producto.comprado
                            ? Icons.check_circle_outline
                            : Icons.pending_outlined,
                        size: 18,
                        color: producto.comprado
                            ? AppColors.verdeElist
                            : const Color(0xFF704800),
                      ),
                      label: Text(estado),
                      backgroundColor: producto.comprado
                          ? AppColors.fondoExito
                          : const Color(0xFFFFF4D6),
                      side: BorderSide(
                        color: producto.comprado
                            ? AppColors.verdeElist
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
