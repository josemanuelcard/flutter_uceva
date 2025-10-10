import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class MealService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> fetchMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=Dessert'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> mealsJson = data['meals'] ?? [];
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las comidas: ${response.statusCode}');
    }
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> mealsJson = data['meals'] ?? [];
      if (mealsJson.isNotEmpty) {
        return MealDetail.fromJson(mealsJson[0]);
      } else {
        throw Exception('Comida no encontrada');
      }
    } else {
      throw Exception('Error al cargar el detalle: ${response.statusCode}');
    }
  }
}
