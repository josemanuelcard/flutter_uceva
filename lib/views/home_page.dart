import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String titulo = "Hola, Flutter";

  void _cambiarTitulo() {
    setState(() {
      titulo = (titulo == "Hola, Flutter")
          ? "¡Título cambiado!"
          : "Hola, Flutter";
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
            // Texto con nombre completo
            const Text(
              "José Manuel Cárdenas Gamboa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Fila de imágenes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  "https://www.uceva.edu.co/wp-content/uploads/2020/07/Uceva-Vertical-png.png",
                  width: 100,
                ),
                Image.asset(
                  "assets/logo.jpg",
                  width: 150
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botón con setState()
            ElevatedButton(
              onPressed: _cambiarTitulo,
              child: const Text("Cambiar título"),
            ),
            const SizedBox(height: 20),

            // BOTÓN MORADO - JWT Auth (FUNCIONALIDAD COMPLETA)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  print("🎉 BOTÓN MORADO PRESIONADO!");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("🎉 ¡Navegando a Autenticación JWT!"),
                      backgroundColor: Colors.purple,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Navega a la funcionalidad JWT completa
                  context.go('/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Ir a Autenticación JWT (Taller JWT)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Container con bordes
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

            // Botón para navegar al módulo HTTP (listado de recetas)
            ElevatedButton(
              onPressed: () {
                // Navegación con go_router al listado de la API
                context.go('/list');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Color para diferenciarlo
              ),
              child: const Text("Ir a Listado de Recetas (Taller HTTP)"),
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
    );
  }
}