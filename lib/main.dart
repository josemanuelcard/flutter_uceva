import 'package:flutter/material.dart';
import 'config/routes.dart';  // Importa las rutas

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UCEVA - Taller HTTP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,  // Usa go_router
    );
  }
}
