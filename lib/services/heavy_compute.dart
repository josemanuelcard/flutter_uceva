// lib/services/heavy_compute.dart
import 'dart:isolate';

Future<int> heavySumIsolate(int n) async {
  final receivePort = ReceivePort();

  // Spawn del isolate que ejecutará _heavyEntryPoint
  await Isolate.spawn(_heavyEntryPoint, receivePort.sendPort);

  // El primer mensaje es el SendPort del isolate
  final sendPort = await receivePort.first as SendPort;

  // Creamos un puerto para recibir respuesta específica de esta petición
  final answerPort = ReceivePort();
  sendPort.send([n, answerPort.sendPort]);

  final result = await answerPort.first as int;

  // cerrar puertos
  answerPort.close();
  receivePort.close();

  return result;
}

void _heavyEntryPoint(SendPort callerPort) {
  final port = ReceivePort();
  // Enviamos nuestro SendPort al que llamó para que pueda comunicarse
  callerPort.send(port.sendPort);

  port.listen((message) {
    final data = message as List;
    final int n = data[0] as int;
    final SendPort replyTo = data[1] as SendPort;

    // Tarea CPU-bound (ejemplo: sumar 0..n)
    int sum = 0;
    for (int i = 0; i <= n; i++) {
      sum += i;
    }

    // Enviar el resultado de vuelta
    replyTo.send(sum);

    // opcional: cerrar listener si solo se hace una sola petición
    port.close();
  });
}
