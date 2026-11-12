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
}
