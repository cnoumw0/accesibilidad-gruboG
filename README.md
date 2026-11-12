# accesibilidad-gruboG
practica final de accesibilidad

# eLIST — Lista de la compra compartida accesible

Aplicación móvil desarrollada en Flutter para gestionar una lista de la compra familiar compartida, con especial énfasis en accesibilidad (WCAG 2.2 AA, TalkBack/VoiceOver).

> **Práctica final** — Accesibilidad · 4.º Grado en Ingeniería Informática · Universidad de León · Curso 2026/2027

## 👥 Equipo

| Nombre |
|--------|
| Iria Rodríguez Fernández |
| Elena García Martín |
| Marcos García Herrero |
| Cephas Bryan Wakan Etokey |

## 🎯 Propuesta

`eLIST` resuelve un problema cotidiano: coordinar la lista de la compra de una familia sin duplicar productos ni perder información cuando varios miembros la editan a la vez. La app está diseñada para ser usable por:

- Personas con baja visión (contraste AA, texto escalable al 200 %).
- Personas con temblor o movilidad reducida (targets ≥ 48×48 lógicos, sin gestos complejos).
- Usuarios de lectores de pantalla (TalkBack/VoiceOver) mediante `Semantics` explícitos.
- Cualquier usuario en situación de uso con una mano, con prisa o con reflejos.

## 🧭 Tres recorridos críticos

| ID | Recorrido | Pantallas implicadas |
|----|-----------|----------------------|
| **R1** | Consultar la lista de la familia | P1 → P2 |
| **R2** | Añadir un producto a la lista compartida | P2 → P3 → P2 |
| **R3** | Gestionar la lista (marcar como comprado, editar, eliminar y deshacer) | P2 → P4 → P2 |

## 📱 Pantallas

| ID | Pantalla | Función |
|----|----------|---------|
| **P1** | Acceso | Entrar al grupo familiar con código o crear uno nuevo. |
| **P2** | Lista de la familia | Pantalla central. Pendientes + comprados, marcar, añadir, editar. |
| **P3** | Añadir producto | Nombre, cantidad, resolución de duplicados. |
| **P4** | Editar producto | Cambiar cantidad, guardar, eliminar con confirmación. |
| **P5** | Actividad reciente | Historial de cambios de los miembros. |
| **P6** | Mi familia | Miembros, código de invitación, cerrar sesión. |

## 🛠️ Stack técnico

- **Flutter** 3.50+ · Dart 3.9+
- **go_router** 14+ (navegación declarativa)
- **Material 3** con `ColorScheme` personalizado
- Sin backend real: datos simulados en memoria
- Sin dependencias externas aparte de `go_router`

## ✅ Requisitos previos

- Flutter SDK ≥ 3.50 instalado y en el `PATH`
- Android Studio con Android SDK ≥ 36 (para APK)
- Chrome (para build web)
- Git

Comprueba tu entorno:

```bash
flutter doctor
```

Debe mostrar ✓ en Flutter, Android toolchain, Chrome y Network resources.

## 🚀 Puesta en marcha

```bash
# 1. Clonar el repositorio
git clone https://github.com/cnoumw0/accesibilidad-gruboG.git
cd accesibilidad-gruboG/app

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar en Chrome (web)
flutter run -d chrome

# 4. Ejecutar en emulador o dispositivo Android
flutter run -d android
```

## 🌐 Build web (GitHub Pages)

La app web se sirve desde `docs/` en la rama `main` para no interferir con el prototipo HTML que vive en la raíz (`index.html`).

```bash
cd app
flutter build web --release --base-href /accesibilidad-gruboG/docs/
cp -r build/web/* ../docs/
```

Luego, en GitHub → **Settings → Pages**:

- **Source**: `Deploy from a branch`
- **Branch**: `main` / **Folder**: `/docs`

URL final: `https://cnoumw0.github.io/accesibilidad-gruboG/docs/`

> El prototipo original sigue disponible en `https://cnoumw0.github.io/accesibilidad-gruboG/`.

## 📦 Build APK

```bash
cd app
flutter build apk --release
```

El APK queda en `app/build/app/outputs/flutter-apk/app-release.apk`. Puedes compartirlo con los compañeros o subirlo como *release* del repositorio.

Para generar un **App Bundle** (formato recomendado por Google Play):

```bash
flutter build appbundle --release
```

## 🗂️ Estructura del proyecto

```
accesibilidad-gruboG/
├── index.html                  # prototipo web original (referencia)
├── README.md                   # este documento
├── docs/                       # build web de Flutter (generado)
└── app/                        # proyecto Flutter
    ├── pubspec.yaml
    ├── android/                # configuración Android
    ├── web/                    # configuración web
    └── lib/
        ├── main.dart
        ├── theme/
        │   └── app_theme.dart
        ├── router/
        │   └── app_router.dart
        ├── models/
        │   └── producto.dart
        ├── widgets/
        │   └── producto_tile.dart
        └── screens/
            ├── acceso_screen.dart
            ├── lista_screen.dart
            ├── anadir_screen.dart
            ├── editar_screen.dart
            ├── actividad_screen.dart
            └── familia_screen.dart
```

## ♿ Accesibilidad implementada

| Requisito | Implementación |
|-----------|----------------|
| RNF-A01 · Contraste | Colores medidos en Memoria v4, sección 22. Todos PASS AA. |
| RNF-A02 · Texto al 200 % | `TextTheme` con alturas y anchos flexibles; sin `textScaleFactor` bloqueado. |
| RNF-A03 · Uso del color | Estados "Pendiente" / "Comprado" siempre con texto, no solo color. |
| RNF-A04 · Targets | `minimumSize: Size(48, 48)` en todos los botones. |
| RNF-A05 · Nombres accesibles | `Semantics(label: ...)` en cada control. |
| RNF-A06 · Orden y agrupación | `MergeSemantics` en cada producto. |
| RNF-A07 · Alternativas a gestos | Acciones de un toque, sin `Dismissible` ni long-press. |
| RNF-A08 · Mensajes | `SnackBar` visible ≥ 6 s y `SemanticsService.announce` para lectores. |
| RNF-A09 · Deshacer | `SnackBar` con acción "Deshacer" tras marcar/eliminar. |

## 🎨 Paleta de colores

| Nombre | Hex | Uso |
|--------|-----|-----|
| Azul | `#16324F` | Cabecera, títulos |
| Verde eLIST | `#12665B` | Acción primaria |
| Fondo | `#F5F7FA` | Fondo general |
| Texto principal | `#243746` | Texto |
| Texto secundario | `#435466` | Ayudas |
| Superficie | `#FFFFFF` | Tarjetas |
| Borde | `#65758B` | Límites |
| Error | `#A61B1B` | Errores |
| Aviso | `#704800` | Avisos |

## 🧪 Verificación de accesibilidad

```bash
# Análisis estático
flutter analyze

# Recomendaciones de accesibilidad (Android)
flutter build apk --debug
# Instalar en dispositivo y ejecutar:
#   - TalkBack (Ajustes → Accesibilidad → TalkBack)
#   - Accessibility Scanner (Play Store)
```

## 🐛 Resolución de problemas

| Problema | Solución |
|----------|----------|
| `flutter doctor` no ve Android | Configura `ANDROID_HOME` y reinicia la terminal. |
| Error de `base-href` en GitHub Pages | Verifica que `--base-href` coincide con la ruta final. |
| `SnackBar` no se anuncia en TalkBack | Usa `SemanticsService.announce` tras `ScaffoldMessenger.showSnackBar`. |
| La build web no encuentra assets | Ejecuta `flutter clean` y vuelve a construir. |

## 📚 Referencias

- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [Flutter Accessibility](https://docs.flutter.dev/ui/accessibility)
- [go_router](https://pub.dev/packages/go_router)
- [ISO/IEC 25010:2023](https://www.iso.org/standard/78176.html)

## 📄 Licencia

Uso académico — Universidad de León, curso 2026/2027.
