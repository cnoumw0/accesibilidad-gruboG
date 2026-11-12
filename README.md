# eLIST — lista de la compra familiar accesible

Proyecto académico de Accesibilidad. eLIST permite que una familia consulte y gestione una lista de compra desde una interfaz móvil. La app Flutter reproduce los seis flujos del prototipo [index.html](index.html) y aplica los requisitos de accesibilidad de la práctica.

> **Estado actual:** prototipo funcional local. Los productos, grupos y actividad se mantienen en memoria mientras la app está abierta. No hay cuentas, servidor ni sincronización entre dispositivos.

## Equipo

| Integrante |
|---|
| Iria Rodríguez Fernández |
| Elena García Martín |
| Marcos García Herrero |
| Cephas Bryan Wakan Etokey |

## Funciones

- Entrar al grupo de ejemplo con el código `FAMILIA24` o crear un grupo local de demostración.
- Consultar productos pendientes y comprados en una misma pantalla.
- Añadir productos y resolver duplicados sumando cantidades sin perder el estado existente.
- Editar nombre y cantidad, marcar productos, eliminarlos con confirmación y deshacer cambios.
- Consultar actividad reciente, ver los miembros de ejemplo y copiar el código de invitación.
- Usar controles etiquetados, objetivos táctiles amplios, estados escritos además de indicados por color, texto escalable y anuncios para lector de pantalla.

### Pantallas

| Pantalla | Responsabilidad |
|---|---|
| Acceso | Entrar con código o crear un grupo de demostración. |
| Lista de la familia | Ver pendientes y comprados, marcar, añadir y abrir edición. |
| Añadir producto | Introducir nombre y cantidad, validar y resolver duplicados. |
| Editar producto | Cambiar datos y eliminar con confirmación. |
| Actividad reciente | Consultar los cambios de ejemplo y los realizados durante la sesión. |
| Mi familia | Ver miembros, copiar el código de invitación y cerrar sesión. |

## Cómo está organizado

Todo el código Flutter está dentro de `app/`.

```text
app/
├── lib/
│   ├── main.dart                 # Arranque y MaterialApp.router
│   ├── router/app_router.dart    # Rutas de go_router
│   ├── models/producto.dart      # Producto y entrada de actividad
│   ├── state/app_state.dart      # Estado compartido y operaciones en memoria
│   ├── theme/app_theme.dart      # Colores, tipografía y estilos Material 3
│   ├── utils/app_feedback.dart   # SnackBars y anuncios accesibles
│   ├── widgets/producto_tile.dart
│   └── screens/                  # Las seis pantallas de eLIST
├── test/widget_test.dart         # Prueba de acceso y carga de la lista
├── pubspec.yaml                  # SDK y dependencias
└── README.md                     # Guía rápida de la app Flutter
```

`AppState` es un `ChangeNotifier` singleton compartido por las pantallas: por eso las altas, cambios y eliminaciones se ven al volver a la lista sin usar un proveedor externo. Guarda una instantánea para deshacer el último marcado o borrado; la opción permanece visible hasta la siguiente modificación. `go_router` gestiona las rutas declaradas en `app_router.dart`. El tema centraliza la paleta y los tamaños mínimos para que los componentes mantengan un aspecto coherente.

## Requisitos para Windows

1. Instala Git y el Flutter SDK para Windows. Añade `flutter\bin` al `PATH`.
2. Instala Android Studio si quieres usar el emulador Android y acepta las licencias del SDK. Para ejecutar en web, instala Chrome.
3. Abre PowerShell y comprueba las herramientas:

```powershell
flutter --version
flutter doctor
```

Para la versión web necesitas Flutter y Chrome. Android Studio/Android SDK solo es necesario para ejecutar en emulador o compilar APK.

## Descargar y ejecutar en Windows

En PowerShell:

```powershell
git clone https://github.com/cnoumw0/accesibilidad-gruboG.git
cd accesibilidad-gruboG\app
flutter pub get
flutter run -d chrome
```

Para Android, inicia un emulador desde Android Studio o conecta un dispositivo con depuración USB activada y ejecuta:

```powershell
flutter devices
flutter run -d android
```

Al abrir la app, introduce `FAMILIA24` para cargar la familia y productos de ejemplo. «Crear un grupo familiar» inicia una lista vacía local. Los cambios no se comparten con otros dispositivos.

### Si se clona en una carpeta ya existente

Si el repositorio ya está descargado, omite `git clone` y cambia directamente al directorio `app`:

```powershell
cd C:\ruta\a\accesibilidad-gruboG\app
flutter pub get
flutter run -d chrome
```

## Análisis y solución aplicada en el equipo

Para revisar el código:

```powershell
cd app
flutter analyze
```

En el entorno de desarrollo del equipo, la migración de Material del SDK se resolvió con:

```powershell
flutter pub add material_ui
dart fix --apply
```

El primer comando añade la biblioteca Material actual del ecosistema Flutter y el segundo aplica las correcciones automáticas disponibles del SDK. Después, vuelve a ejecutar `flutter pub get` y `flutter analyze` para comprobar el resultado.

## Prueba y accesibilidad

Ejecuta la prueba de widgets desde `app/` con:

```powershell
flutter test
```

Para una revisión manual, recorre acceso → lista, añadir un producto y gestionar (marcar, editar, eliminar y deshacer). Prueba también con el tamaño de texto ampliado y un lector de pantalla. Comprueba que los estados se anuncian con texto y que los controles tengan nombres que describan su acción.

## Compilar

Web:

```powershell
cd app
flutter build web --release --base-href /accesibilidad-gruboG/docs/
```

Android APK:

```powershell
cd app
flutter build apk --release
```

El APK se genera en `app\build\app\outputs\flutter-apk\app-release.apk`. La publicación en GitHub Pages requiere copiar el contenido de `app\build\web` a `docs/` y configurar Pages para servir esa carpeta.

## Prototipo HTML

`index.html` en la raíz es el prototipo web original y permanece independiente de la app Flutter. Se puede abrir localmente en un navegador; la aplicación Flutter se ejecuta desde `app/`.

## Stack

- Flutter y Dart según las restricciones de `app/pubspec.yaml`.
- Material 3 para la interfaz.
- `go_router` para navegación declarativa.
- Datos simulados en memoria, sin backend ni persistencia.

Uso académico — Universidad de León, curso 2026/2027.
