import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/counter_widget.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final Object? extra; // puede ser un Item pasado via extra

  const DetailScreen({super.key, required this.id, this.extra});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Item? receivedItem;

  // initState: se llama una vez cuando se crea el State.
  // Ideal para inicializar variables que no dependen del BuildContext.
  @override
  void initState() {
    super.initState();
    print('DetailScreen.initState() - Widget creado (id=${widget.id})');
  }

  // didChangeDependencies: se llama justo después de initState y cuando cambian dependencias.
  // Útil si necesitas consultar InheritedWidgets o Provider.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('DetailScreen.didChangeDependencies() - dependencias listas');
    // Si enviaron un Item via extra, lo guardamos aquí para usarlo en build.
    if (widget.extra is Item) {
      receivedItem = widget.extra as Item;
    }
  }

  // build: se llama cada vez que se necesita renderizar la UI.
  @override
  Widget build(BuildContext context) {
    print('DetailScreen.build() - mostrando detalle id=${widget.id}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle - ${widget.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('ID recibido (path param): ${widget.id}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            if (receivedItem != null) ...[
              Text('Título extra: ${receivedItem!.title}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              Text(receivedItem!.description),
              const SizedBox(height: 12),
              Image.network(receivedItem!.imageUrl, height: 180, fit: BoxFit.cover),
            ] else
              const Text('No se recibió un objeto extra (se usó sólo el path param).'),
            const SizedBox(height: 20),
            const Text('Widget Counter (ejemplo de setState y ciclo de vida):'),
            const SizedBox(height: 8),
            const CounterWidget(), // aquí también verás prints de su ciclo de vida
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ejemplo de setState local: cambiaremos un texto (simulado)
                setState(() {
                  // aquí solo para evidenciar setState en este State
                  print('DetailScreen.setState() - llamado manual desde botón');
                });
              },
              child: const Text('Forzar setState (ver consola)'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Prueba: usa los botones Go / Push / Replace desde Home y observa '
              'el comportamiento del botón "Atrás" del dispositivo o la flecha superior.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // dispose: se llama cuando el State se elimina permanentemente.
  @override
  void dispose() {
    print('DetailScreen.dispose() - estado destruido (id=${widget.id})');
    super.dispose();
  }
}
