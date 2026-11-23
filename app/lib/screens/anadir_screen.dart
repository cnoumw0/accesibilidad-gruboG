import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/categoria.dart';
import '../models/producto.dart';
import '../state/app_state.dart';
import '../utils/app_feedback.dart';
import '../widgets/campo_supermercado.dart';
import '../widgets/selector_categoria.dart';

class AnadirScreen extends StatefulWidget {
  const AnadirScreen({super.key});

  @override
  State<AnadirScreen> createState() => _AnadirScreenState();
}

class _AnadirScreenState extends State<AnadirScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreFocus = FocusNode();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController(text: '1');
  final _notaController = TextEditingController();
  final _supermercadoController = TextEditingController();
  Producto? _duplicado;
  Categoria _categoria = Categoria.otros;

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _notaController.dispose();
    _supermercadoController.dispose();
    _nombreFocus.dispose();
    super.dispose();
  }

  int? _cantidad() {
    final value = int.tryParse(_cantidadController.text.trim());
    if (value == null || value < 1) return null;
    return value;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      // El error se ve bajo el campo; también se anuncia al lector de pantalla.
      AppFeedback.announce(
        context,
        'No se ha podido añadir. Revisa el mensaje de error bajo cada campo.',
      );
      return;
    }
    final appState = AppState.instance;
    final duplicate = appState.buscarDuplicado(_nombreController.text);
    if (duplicate != null) {
      setState(() => _duplicado = duplicate);
      return;
    }
    _addProduct();
  }

  void _addProduct() {
    final name = _nombreController.text.trim();
    final quantity = _cantidad()!;
    final wasDuplicate = AppState.instance.buscarDuplicado(name) != null;
    AppState.instance.anadir(
      name,
      quantity,
      _categoria,
      _notaController.text,
      _supermercadoController.text,
    );
    AppFeedback.mostrarEnLista(
      context,
      wasDuplicate
          ? 'Se añadieron $quantity unidades a $name.'
          : '$name añadido a la lista.',
    );
    context.go('/lista');
  }

  void _renameInstead() {
    setState(() => _duplicado = null);
    _nombreController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _nombreController.text.length,
    );
    FocusScope.of(context).requestFocus(_nombreFocus);
  }

  @override
  Widget build(BuildContext context) {
    final duplicate = _duplicado;
    final quantity = _cantidad();
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir producto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SelectorCategoria(
              categoria: _categoria,
              onCategoria: (value) => setState(() => _categoria = value),
              onSugerencia: (nombre) => setState(() {
                _nombreController.text = nombre;
                _duplicado = null;
              }),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('productNameField'),
              controller: _nombreController,
              focusNode: _nombreFocus,
              textInputAction: TextInputAction.next,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
              ),
              onChanged: (_) {
                if (_duplicado != null) setState(() => _duplicado = null);
              },
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Falta el nombre del producto. Escríbelo para añadirlo a la lista.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('productQuantityField'),
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Cantidad (unidades)',
              ),
              onChanged: (_) => setState(() {}),
              validator: (_) => _cantidad() == null
                  ? 'La cantidad no es válida. Escribe un número entero mayor que cero, por ejemplo 1.'
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('productNoteField'),
              controller: _notaController,
              textInputAction: TextInputAction.next,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Observaciones (opcional)',
                helperText: 'Por ejemplo, una marca o un tipo concreto.',
              ),
            ),
            const SizedBox(height: 16),
            CampoSupermercado(controller: _supermercadoController),
            if (duplicate != null) ...[
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF704800)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${duplicate.nombre} ya existe: ${duplicate.cantidad} '
                        '${duplicate.cantidad == 1 ? 'unidad' : 'unidades'}, '
                        '${duplicate.estado}. ¿Quieres sumar ${quantity ?? 1} '
                        '${quantity == 1 ? 'unidad' : 'unidades'} o renombrar '
                        'el producto? Si sumas, ${duplicate.nombre} conservará '
                        'su estado actual (${duplicate.estado}).',
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: quantity == null ? null : _addProduct,
                        child: const Text('Sumar cantidad al existente'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _renameInstead,
                        child: const Text('Renombrar producto'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            FilledButton(
              onPressed: _submit,
              child: const Text('Añadir a la lista'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go('/lista'),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
