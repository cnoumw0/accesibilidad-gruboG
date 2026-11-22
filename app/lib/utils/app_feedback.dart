import 'package:material_ui/material_ui.dart';
import 'package:flutter/semantics.dart';

class AppFeedback {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Espera antes de anunciar un mensaje que llega junto con un cambio de
  /// pantalla: TalkBack anuncia primero la pantalla nueva y descarta los
  /// anuncios que le llegan mientras tanto.
  static const _esperaCambioDePantalla = Duration(milliseconds: 900);

  static void show(BuildContext context, String message) {
    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 6)),
      );
    final view = View.of(context);
    Future.delayed(_esperaCambioDePantalla, () {
      SemanticsService.sendAnnouncement(view, message, TextDirection.ltr);
    });
  }

  /// Anuncia un mensaje al lector de pantalla sin mostrar un aviso visual.
  /// Se usa cuando el error ya se ve escrito bajo el campo del formulario y
  /// no se cambia de pantalla.
  static void announce(BuildContext context, String message) {
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      TextDirection.ltr,
    );
  }
}
