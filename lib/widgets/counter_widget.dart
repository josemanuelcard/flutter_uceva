import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int value = 0;

  // initState: se llama una vez cuando se monta el State (inicializaciones).
  @override
  void initState() {
    super.initState();
    print('CounterWidget.initState() - inicializando contador');
  }

  // didChangeDependencies: se llama después de initState y cuando cambian dependencias (ej. InheritedWidget).
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('CounterWidget.didChangeDependencies() - dependencias listas o cambiaron');
  }

  // build: se llama cada vez que el framework necesita renderizar este widget (tras setState, por ejemplo).
  @override
  Widget build(BuildContext context) {
    print('CounterWidget.build() - construyendo UI con value=$value');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Contador: $value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              value += 1;
              // setState: aquí actualizamos el estado local; build() se ejecutará después.
              print('CounterWidget.setState() -> value=$value');
            });
          },
          child: const Text('Incrementar'),
        ),
      ],
    );
  }

  // dispose: se llama cuando el State se elimina (cerrar streams, controllers...).
  @override
  void dispose() {
    print('CounterWidget.dispose() - limpiando recursos');
    super.dispose();
  }
}
