import 'package:material_ui/material_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/foundation.dart';

class AppFeedback {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Espera antes de anunciar un mensaje que llega junto con un cambio de
  /// pantalla: TalkBack anuncia primero la pantalla nueva y descarta los
  /// anuncios que le llegan mientras tanto.
  static const _esperaCambioDePantalla = Duration(milliseconds: 900);

  /// Aviso que la pantalla Lista lee desde su propia región en directo. Se usa
  /// para los mensajes que se muestran en la Lista (añadir, editar, marcar):
  /// así TalkBack los lee aunque la pantalla acabe de cambiar o el foco se
  /// haya movido. Cada aviso es un objeto nuevo, para que se notifique aunque
  /// el texto se repita.
  static final ValueNotifier<Aviso?> avisoLista = ValueNotifier<Aviso?>(null);

  /// Envía el aviso a la pantalla Lista, que lo muestra arriba y TalkBack lo
  /// lee. No usa SnackBar ni SemanticsService, para que no se lea dos veces.
  static void mostrarEnLista(BuildContext context, String message) {
    messengerKey.currentState?.hideCurrentSnackBar();
    avisoLista.value = Aviso(message);
  }

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

/// Texto de un aviso para la Lista. Cada instancia es distinta.
class Aviso {
  const Aviso(this.texto);
  final String texto;
}
