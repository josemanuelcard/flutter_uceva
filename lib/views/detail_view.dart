import 'package:flutter/material.dart';
import '../services/meal_service.dart';
import '../models/meal_model.dart';

class DetailViewScreen extends StatefulWidget {
  final String id;
  final String name;

  const DetailViewScreen({super.key, required this.id, required this.name});

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {
  late Future<MealDetail> futureDetail;
  final MealService _mealService = MealService();

  @override
  void initState() {
    super.initState();
    futureDetail = _loadDetail();
  }

  Future<MealDetail> _loadDetail() async {
    try {
      return await _mealService.fetchMealDetail(widget.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar detalle: $e'), backgroundColor: Colors.red),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Uri.decodeComponent(widget.name)),
      ),
      body: FutureBuilder<MealDetail>(
        future: futureDetail,
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
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureDetail = _loadDetail();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            final detail = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      detail.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 200),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Instrucciones:', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(detail.instructions, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Text('Ingredientes:', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  ...detail.ingredients.map((ingredient) => Text('• $ingredient')),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}