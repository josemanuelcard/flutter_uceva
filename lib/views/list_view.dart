import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/meal_service.dart';
import '../models/meal_model.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  late Future<List<Meal>> futureMeals;
  final MealService _mealService = MealService();

  @override
  void initState() {
    super.initState();
    futureMeals = _loadMeals();  // Carga en initState, no en build
  }

  Future<List<Meal>> _loadMeals() async {
    try {
      return await _mealService.fetchMeals();
    } catch (e) {
      // Manejo de error: muestra snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de red: $e'), backgroundColor: Colors.red),
        );
      }
      rethrow;  // Para que FutureBuilder maneje el error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Recetas (TheMealDB)')),
      body: FutureBuilder<List<Meal>>(
        future: futureMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureMeals = _loadMeals();  // Recarga
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            final meals = snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return ListTile(
                  leading: Image.network(
                    meal.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                  title: Text(meal.name),
                  onTap: () {
                    // Navegación con go_router, pasando parámetros
                    context.go('/detail/${meal.id}/${Uri.encodeComponent(meal.name)}');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}