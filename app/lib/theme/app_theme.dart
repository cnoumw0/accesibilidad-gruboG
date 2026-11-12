import 'package:material_ui/material_ui.dart';

/// Paleta oficial de eLIST (Memoria v4, sección 21).
class AppColors {
  static const azul = Color(0xFF16324F);
  static const verdeElist = Color(0xFF12665B);
  static const fondo = Color(0xFFF5F7FA);
  static const textoPrincipal = Color(0xFF243746);
  static const textoSecundario = Color(0xFF435466);
  static const superficie = Color(0xFFFFFFFF);
  static const borde = Color(0xFF65758B);
  static const error = Color(0xFFA61B1B);
  static const aviso = Color(0xFF704800);

  // Fondos suaves de estado
  static const fondoInfo = Color(0xFFEAF1F8);
  static const fondoExito = Color(0xFFE8F3F0);
  static const fondoError = Color(0xFFFCEEEE);
  static const fondoAviso = Color(0xFFFFF4D6);
}

class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.verdeElist,
      onPrimary: Colors.white,
      secondary: AppColors.azul,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.superficie,
      onSurface: AppColors.textoPrincipal,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.fondo,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: AppColors.textoPrincipal,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textoPrincipal,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: AppColors.textoPrincipal,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textoSecundario),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: AppColors.verdeElist,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: AppColors.textoPrincipal,
          side: const BorderSide(color: AppColors.borde),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.verdeElist, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.azul,
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
        actionTextColor: Colors.white,
        showCloseIcon: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.superficie,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textoPrincipal,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: AppColors.textoPrincipal,
        ),
      ),
    );
  }
}
