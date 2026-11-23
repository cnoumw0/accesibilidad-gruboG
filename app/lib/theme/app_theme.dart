import 'package:material_ui/material_ui.dart';

/// Paleta oficial de eLIST (Memoria v4, sección 21).
class AppColors {
  static const azul = Color(0xFF16324F);
  // Verde lechuga. «verdeElist» es la versión oscura que se usa en botones y en
  // texto sobre fondo claro (contraste 5,5:1 con blanco); los dos verdes claros
  // solo se usan en detalles decorativos y en el borde de foco (3:1 mínimo).
  static const verdeElist = Color(0xFF467529);
  static const verdeLechuga = Color(0xFF588C3A);
  static const verdeHoja = Color(0xFF4A9E4D);
  static const fondo = Color(0xFFF4F9EE);
  static const textoPrincipal = Color(0xFF243746);
  static const textoSecundario = Color(0xFF435466);
  static const superficie = Color(0xFFFFFFFF);
  static const borde = Color(0xFF65758B);
  static const error = Color(0xFFA61B1B);
  static const aviso = Color(0xFF704800);

  // Fondos suaves de estado
  static const fondoInfo = Color(0xFFEAF1F8);
  static const fondoExito = Color(0xFFEAF5E4);
  static const bordeSuave = Color(0xFFC9DFBE);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.bordeSuave),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: AppColors.verdeElist,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: AppColors.textoPrincipal,
          side: const BorderSide(color: AppColors.borde),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.verdeHoja, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.all(Radius.circular(16)),
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
