import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/routes.dart';  // Importa las rutas (sin ciclo)
import 'screens/taller_segundo_plano_screen.dart'; // <-- Importa la pantalla del taller

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/taller': (context) => const TallerSegundoPlanoScreen(), // Ruta al taller
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String titulo = "Hola, Flutter";

  void _cambiarTitulo() {
    setState(() {
      titulo = (titulo == "Hola, Flutter") ? "¡Título cambiado!" : "Hola, Flutter";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Título actualizado")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "José Manuel Cárdenas Gamboa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  "https://www.uceva.edu.co/wp-content/uploads/2020/07/Uceva-Vertical-png.png",
                  width: 100,
                ),
                Image.asset("assets/logo.jpg", width: 150),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _cambiarTitulo,
              child: const Text("Cambiar título"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/taller'); // Navega al taller
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Ir al Taller Segundo Plano"),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("Soy un Container con bordes"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.school, color: Colors.blue),
                    title: Text("Estudio Ingeniería de Sistemas"),
                  ),
                  ListTile(
                    leading: Icon(Icons.flutter_dash, color: Colors.cyan),
                    title: Text("Me gusta Flutter"),
                  ),
                  ListTile(
                    leading: Icon(Icons.sports_soccer, color: Colors.green),
                    title: Text("Me gusta el fútbol"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      routerConfig: router,  // Usa go_router
    );
  }
}