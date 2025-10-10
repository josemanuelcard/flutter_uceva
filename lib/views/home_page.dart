import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String titulo = "Hola, Flutter";

  @override
  void initState() {
    super.initState();
    debugPrint('HomePage: initState');
  }

  void _cambiarTitulo() {
    setState(() {
      titulo = (titulo == "Hola, Flutter") ? "¡Título cambiado!" : "Hola, Flutter";
    });
    debugPrint('HomePage: título cambiado -> $titulo');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Título actualizado")),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HomePage: build');
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          // botón de prueba en la AppBar para comprobar navegación
          IconButton(
            tooltip: 'Ir a /list (AppBar)',
            icon: const Icon(Icons.list),
            onPressed: () {
              debugPrint('AppBar IconButton pressed -> navegando a /list');
              context.go('/list');
            },
          ),
        ],
      ),

      // Body: Scrollable dentro de Expanded para evitar overflows
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "José Manuel Cárdenas Gamboa",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Imágenes con fallback
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        "https://www.uceva.edu.co/wp-content/uploads/2020/07/Uceva-Vertical-png.png",
                        width: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.school, size: 100, color: Colors.blue),
                      ),
                      // Si el asset no existe, verás el icono del error en consola.
                      Image.asset(
                        "assets/logo.jpg",
                        width: 150,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 80),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _cambiarTitulo,
                    child: const Text("Cambiar título"),
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

                  // Items (ya no usamos Expanded ListView aquí para evitar conflictos con scroll)
                  const ListTile(
                    leading: Icon(Icons.school, color: Colors.blue),
                    title: Text("Estudio Ingeniería de Sistemas"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.flutter_dash, color: Colors.cyan),
                    title: Text("Me gusta Flutter"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.sports_soccer, color: Colors.green),
                    title: Text("Me gusta el fútbol"),
                  ),

                  // espacio para simular contenido y forzar scroll si es necesario
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),

      // ------------ AQUI: botón del Taller HTTP garantizado y visible ------------
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ElevatedButton(
            onPressed: () {
              debugPrint('Bottom button pressed -> navegando a /list');
              context.go('/list');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text("Ir a Listado de Recetas (Taller HTTP)"),
          ),
        ),
      ),

      // botón flotante adicional para verificar visualización/navegación
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ir a /list (FAB)',
        onPressed: () {
          debugPrint('FAB pressed -> navegando a /list');
          context.go('/list');
        },
        child: const Icon(Icons.chevron_right),
      ),
    );
  }
}
