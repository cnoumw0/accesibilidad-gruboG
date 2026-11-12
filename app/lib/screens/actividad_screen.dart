import 'package:material_ui/material_ui.dart';

import '../state/app_state.dart';

class ActividadScreen extends StatelessWidget {
  const ActividadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad reciente')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: appState.actividad.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final entry = appState.actividad[index];
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(entry.mensaje),
                subtitle: Text(entry.tiempo),
                contentPadding: const EdgeInsets.all(12),
              ),
            );
          },
        ),
      ),
    );
  }
}
