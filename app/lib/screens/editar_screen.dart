import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/categoria.dart';
import '../models/producto.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/app_feedback.dart';
import '../widgets/campo_supermercado.dart';
import '../widgets/selector_categoria.dart';

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
  final _notaController = TextEditingController();
  final _supermercadoController = TextEditingController();
  Categoria _categoria = Categoria.otros;
  bool _initialized = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _notaController.dispose();
    _supermercadoController.dispose();
    super.dispose();
  }

  void _initialize(Producto item) {
    if (_initialized) return;
    _nombreController.text = item.nombre;
    _cantidadController.text = '${item.cantidad}';
    _categoria = item.categoria;
    _notaController.text = item.nota;
    _supermercadoController.text = item.supermercado;
    _initialized = true;
  }

  int? _quantity() {
    final quantity = int.tryParse(_cantidadController.text.trim());
    return quantity != null && quantity > 0 ? quantity : null;
  }

  void _save(Producto item) {
    if (!_formKey.currentState!.validate()) {
      // El error se ve bajo el campo; también se anuncia al lector de pantalla.
      AppFeedback.announce(
        context,
        'No se han podido guardar los cambios. Revisa el mensaje de error bajo cada campo.',
      );
      return;
    }
    final duplicate = AppState.instance.buscarDuplicado(_nombreController.text);
    if (duplicate != null && duplicate.id != item.id) {
      _formKey.currentState!.validate();
      return;
    }
    AppState.instance.guardarEdicion(
      item.id,
      _nombreController.text,
      _quantity()!,
      _categoria,
      _notaController.text,
      _supermercadoController.text,
    );
    AppFeedback.mostrarEnLista(context, 'Cambios guardados.');
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
    AppFeedback.mostrarEnLista(context, '${item.nombre} eliminado. Puedes deshacer.');
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
            SelectorCategoria(
              categoria: _categoria,
              onCategoria: (value) => setState(() => _categoria = value),
              onSugerencia: (nombre) => setState(() => _nombreController.text = nombre),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Falta el nombre del producto. Escríbelo para guardar los cambios.';
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
                  ? 'La cantidad no es válida. Escribe un número entero mayor que cero, por ejemplo 1.'
                  : null,
            ),
            // Campos opcionales plegados: así el formulario principal es corto.
            ExpansionTile(
              title: const Text('Más detalles (opcional)'),
              subtitle: const Text('Observaciones y supermercado'),
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 8),
              shape: const Border(),
              collapsedShape: const Border(),
              initiallyExpanded: item.nota.isNotEmpty || item.supermercado.isNotEmpty,
              children: [
                TextFormField(
                  key: const Key('productNoteField'),
                  controller: _notaController,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    helperText: 'Una marca o un tipo',
                  ),
                ),
                const SizedBox(height: 16),
                CampoSupermercado(controller: _supermercadoController),
              ],
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
                    ? AppColors.fondoExito
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
