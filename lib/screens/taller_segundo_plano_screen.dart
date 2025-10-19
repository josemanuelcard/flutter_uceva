import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

class TallerSegundoPlanoScreen extends StatefulWidget {
  const TallerSegundoPlanoScreen({super.key});

  @override
  State<TallerSegundoPlanoScreen> createState() => _TallerSegundoPlanoScreenState();
}

class _TallerSegundoPlanoScreenState extends State<TallerSegundoPlanoScreen> {
  // ---- Future / async / await ----
  String dataState = "Presiona para cargar datos...";

  Future<void> _loadData() async {
    print("Antes de la consulta");
    setState(() => dataState = "Cargando...");

    try {
      final result = await Future.delayed(
        const Duration(seconds: 3),
        () => "Datos cargados correctamente ✅",
      );

      print("Durante la consulta");
      setState(() => dataState = result);
    } catch (e) {
      setState(() => dataState = "Error al cargar los datos ❌");
    }

    print("Después de la consulta");
  }

  // ---- Timer (cronómetro) ----
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() => _seconds = 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---- Isolate (tarea pesada) ----
  String _isolateResult = "Sin ejecutar";

  static void _heavyTask(SendPort sendPort) {
    int sum = 0;
    for (int i = 0; i < 200000000; i++) {
      sum += i;
    }
    sendPort.send(sum);
  }

  Future<void> _runIsolate() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_heavyTask, receivePort.sendPort);
    receivePort.listen((message) {
      setState(() {
        _isolateResult = "Resultado de Isolate: $message";
      });
    });
  }

  // ---- UI ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Taller Segundo Plano")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("1️⃣ Future / async / await", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(dataState),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _loadData, child: const Text("Cargar datos")),
            const Divider(),

            const Text("2️⃣ Timer (Cronómetro)", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("$_seconds s", style: const TextStyle(fontSize: 32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _startTimer, child: const Text("Iniciar")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _pauseTimer, child: const Text("Pausar")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _resetTimer, child: const Text("Reiniciar")),
              ],
            ),
            const Divider(),

            const Text("3️⃣ Isolate (Tarea Pesada)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(_isolateResult),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _runIsolate,
              child: const Text("Ejecutar tarea pesada"),
            ),
          ],
        ),
      ),
    );
  }
}
