import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../state/app_state.dart';
import '../utils/app_feedback.dart';

class AccesoScreen extends StatefulWidget {
  const AccesoScreen({super.key});

  @override
  State<AccesoScreen> createState() => _AccesoScreenState();
}

class _AccesoScreenState extends State<AccesoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _creating = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      // El error se ve bajo el campo; también se anuncia al lector de pantalla.
      AppFeedback.announce(
        context,
        _creating
            ? 'No se ha podido crear el grupo. Revisa el mensaje de error bajo el campo.'
            : 'No se ha podido entrar. Revisa el mensaje de error bajo el campo.',
      );
      return;
    }
    if (_creating) {
      AppState.instance.crearGrupo(_codeController.text);
      AppFeedback.show(context, 'Grupo ${_codeController.text.trim()} creado.');
      context.go('/lista');
      return;
    }
    AppState.instance.entrar();
    AppFeedback.show(context, 'Has entrado en Familia Gómez.');
    context.go('/lista');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título de la pantalla: TalkBack lo anuncia como encabezado.
                    Semantics(
                      header: true,
                      child: Text(
                        'eLIST',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontSize: 36,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lista de la compra compartida',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      key: const Key('familyCodeField'),
                      controller: _codeController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: _creating
                            ? 'Nombre de la familia'
                            : 'Código de familia',
                        hintText: _creating ? 'Familia Gómez' : 'FAMILIA24',
                        helperText: _creating
                            ? 'Se creará un grupo de demostración.'
                            : 'Introduce el código de invitación de tu familia.',
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return _creating
                              ? 'Falta el nombre de la familia. Escríbelo para crear el grupo.'
                              : 'Falta el código de familia. Escríbelo para entrar.';
                        }
                        if (!_creating &&
                            text.toUpperCase() != AppState.codigoFamilia) {
                          return 'Código no válido. Revisa el código de invitación y vuelve a escribirlo.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(
                        _creating
                            ? 'Crear grupo familiar'
                            : 'Entrar en mi familia',
                      ),
                    ),
                    if (!_creating) ...[
                      // Separador decorativo: no aporta nada al lector de pantalla.
                      const ExcludeSemantics(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('o', textAlign: TextAlign.center),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _creating = true;
                            _codeController.clear();
                          });
                        },
                        child: const Text('Crear un grupo familiar'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '¿No tienes un código de familia? Pide a un familiar que te lo envíe.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => setState(() {
                          _creating = false;
                          _codeController.clear();
                        }),
                        child: const Text('Volver al acceso'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
