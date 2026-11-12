import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/producto.dart';
import '../state/app_state.dart';
import '../utils/app_feedback.dart';

class EditarScreen extends StatefulWidget {
  const EditarScreen({required this.id, super.key});

  final String id;

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  void _initialize(Producto item) {
    if (_initialized) return;
    _nombreController.text = item.nombre;
    _cantidadController.text = '${item.cantidad}';
    _initialized = true;
  }

  int? _quantity() {
    final quantity = int.tryParse(_cantidadController.text.trim());
    return quantity != null && quantity > 0 ? quantity : null;
  }

  void _save(Producto item) {
    if (!_formKey.currentState!.validate()) return;
    final duplicate = AppState.instance.buscarDuplicado(_nombreController.text);
    if (duplicate != null && duplicate.id != item.id) {
      _formKey.currentState!.validate();
      return;
    }
    AppState.instance.guardarEdicion(
      item.id,
      _nombreController.text,
      _quantity()!,
    );
    AppFeedback.show(context, 'Cambios guardados.');
    context.go('/lista');
  }

  Future<void> _confirmDelete(Producto item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('¿Eliminar ${item.nombre}?'),
        content: const Text(
          'La opción de deshacer permanecerá disponible en la lista '
          'hasta la siguiente modificación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    AppState.instance.eliminar(item.id);
    AppFeedback.show(context, '${item.nombre} eliminado. Puedes deshacer.');
    context.go('/lista');
  }

  @override
  Widget build(BuildContext context) {
    final item = AppState.instance.producto(widget.id);
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar producto')),
        body: const Center(child: Text('No se encontró el producto.')),
      );
    }
    _initialize(item);
    return Scaffold(
      appBar: AppBar(title: const Text('Editar producto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Falta el nombre del producto.';
                }
                final duplicate = AppState.instance.buscarDuplicado(
                  value.trim(),
                );
                if (duplicate != null && duplicate.id != item.id) {
                  return '${duplicate.nombre} ya está en la lista. Cambia el nombre para evitar duplicados.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad (unidades)',
              ),
              validator: (_) => _quantity() == null
                  ? 'La cantidad debe ser un número entero mayor que cero.'
                  : null,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: Icon(
                  item.comprado
                      ? Icons.check_circle_outline
                      : Icons.pending_outlined,
                ),
                label: Text(item.estado),
                backgroundColor: item.comprado
                    ? const Color(0xFFE8F3F0)
                    : const Color(0xFFFFF4D6),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _save(item),
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go('/lista'),
              child: const Text('Cancelar'),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _confirmDelete(item),
              icon: const Icon(Icons.delete_outline),
              label: Text('Eliminar ${item.nombre}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
