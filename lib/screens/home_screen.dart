import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Lista de items de ejemplo
  final List<Map<String, String>> items = const [
    {
      "title": "Ingeniería de Sistemas",
      "description": "Explora proyectos de software, IA y bases de datos.",
      "imageUrl": "https://picsum.photos/200/100",
    },
    {
      "title": "Fútbol",
      "description": "Últimas noticias sobre tu equipo favorito.",
      "imageUrl": "https://picsum.photos/200/101",
    },
    {
      "title": "Turismo",
      "description": "Descubre los mejores lugares para viajar.",
      "imageUrl": "https://picsum.photos/200/102",
    },
    {
      "title": "Tecnología",
      "description": "Novedades sobre inteligencia artificial y gadgets.",
      "imageUrl": "https://picsum.photos/200/103",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pantalla Principal"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              // Enviamos el título como parámetro
              context.push(
                '/detail',
                extra: item['title'],
              );
            },
            child: InfoCard(
              title: item['title']!,
              description: item['description']!,
              imageUrl: item['imageUrl'],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/tabs');
              },
              child: const Text("Ir con GO"),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/tabs');
              },
              child: const Text("Ir con PUSH"),
            ),
            ElevatedButton(
              onPressed: () {
                context.replace('/tabs');
              },
              child: const Text("Ir con REPLACE"),
            ),
          ],
        ),
      ),
    );
  }
}
