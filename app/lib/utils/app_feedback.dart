import 'package:material_ui/material_ui.dart';
import 'package:flutter/semantics.dart';

class AppFeedback {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(BuildContext context, String message) {
    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 6)),
      );
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      TextDirection.ltr,
    );
  }

  /// Anuncia un mensaje al lector de pantalla sin mostrar un aviso visual.
  /// Se usa cuando el error ya se ve escrito bajo el campo del formulario.
  static void announce(BuildContext context, String message) {
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      TextDirection.ltr,
    );
  }
}
