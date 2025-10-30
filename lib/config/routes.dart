import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';  // Importa HomeScreen desde screens
import '../views/home_page.dart';  // Importa HomePage desde views
import '../views/list_view.dart';
import '../views/detail_view.dart';
import '../auth/views/simple_auth_screen.dart';
import '../auth/views/evidencia_local_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/views',
      name: 'views',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const SimpleAuthScreen(),
    ),
    GoRoute(
      path: '/list',
      name: 'list',
      builder: (context, state) => const ListViewScreen(),
    ),
    GoRoute(
      path: '/detail/:id/:name',
      name: 'detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final name = state.pathParameters['name']!;
        return DetailViewScreen(id: id, name: name);
      },
    ),
    GoRoute(
      path: '/evidencia',
      name: 'evidencia',
      builder: (context, state) => const EvidenciaLocalScreen(),
    ),
  ],
);