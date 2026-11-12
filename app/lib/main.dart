import 'package:material_ui/material_ui.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'utils/app_feedback.dart';

void main() {
  runApp(const ElistApp());
}

class ElistApp extends StatelessWidget {
  const ElistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'eLIST',
      theme: AppTheme.light,
      routerConfig: appRouter,
      scaffoldMessengerKey: AppFeedback.messengerKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
