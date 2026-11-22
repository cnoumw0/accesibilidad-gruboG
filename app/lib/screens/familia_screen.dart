import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../state/app_state.dart';
import '../utils/app_feedback.dart';

class FamiliaScreen extends StatelessWidget {
  const FamiliaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi familia')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.familyName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    // Solo texto visible: antes una etiqueta repetía lo mismo
                    // y TalkBack leía el código dos veces.
                    const Text(
                      'Código de invitación: ${AppState.codigoFamilia}',
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          const ClipboardData(text: AppState.codigoFamilia),
                        );
                        if (!context.mounted) return;
                        AppFeedback.show(
                          context,
                          'Código de invitación copiado.',
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar código'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              header: true,
              child: Text(
                'Miembros',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Ana'),
                    subtitle: Text('Administradora'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Luis'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Marta'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => AppFeedback.show(
                context,
                'Invita a un miembro compartiendo el código FAMILIA24.',
              ),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Invitar miembro'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                appState.cerrarSesion();
                AppFeedback.show(context, 'Sesión cerrada.');
                context.go('/');
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
