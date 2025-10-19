import 'package:go_router/go_router.dart';
import '../views/home_page.dart';  // Importa HomePage
import '../views/list_view.dart';
import '../views/detail_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',  // Inicia en HomePage
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
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
  ],
);