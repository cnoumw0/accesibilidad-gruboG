import 'package:go_router/go_router.dart';

import '../screens/acceso_screen.dart';
import '../screens/actividad_screen.dart';
import '../screens/anadir_screen.dart';
import '../screens/editar_screen.dart';
import '../screens/familia_screen.dart';
import '../screens/lista_screen.dart';
import '../screens/menu_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AccesoScreen()),
    GoRoute(path: '/lista', builder: (context, state) => const ListaScreen()),
    GoRoute(path: '/anadir', builder: (context, state) => const AnadirScreen()),
    GoRoute(
      path: '/editar/:id',
      builder: (context, state) =>
          EditarScreen(id: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(path: '/menu', builder: (context, state) => const MenuScreen()),
    GoRoute(
      path: '/actividad',
      builder: (context, state) => const ActividadScreen(),
    ),
    GoRoute(
      path: '/familia',
      builder: (context, state) => const FamiliaScreen(),
    ),
  ],
);
