// lib/services/mock_service.dart
class MockService {
  /// Simula una consulta remota con delay.
  /// Si fail=true lanza una excepción para probar el estado Error.
  Future<List<String>> fetchItems({bool fail = false}) async {
    print('MockService: Antes de delay (llamada iniciada)');
    await Future.delayed(const Duration(seconds: 2));
    print('MockService: Delay terminado');

    if (fail) {
      print('MockService: Lanzando excepción simulada');
      throw Exception('Error simulado en MockService');
    }

    final items = List<String>.generate(5, (i) => 'Elemento ${i + 1}');
    print('MockService: Retornando ${items.length} elementos');
    return items;
  }
}
