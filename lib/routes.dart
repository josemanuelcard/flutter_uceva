import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/tabs_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // Ruta para Detail con parámetro path y posible extra (Item)
    GoRoute(
      path: '/detail/:id',
      name: 'detail',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final extra = state.extra;
        return DetailScreen(id: id ?? 'no-id', extra: extra);
      },
    ),
    GoRoute(
      path: '/tabs',
      name: 'tabs',
      builder: (context, state) => const TabsScreen(),
    ),
  ],
);
