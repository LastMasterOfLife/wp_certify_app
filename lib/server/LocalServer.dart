import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class LocalServer {
  static final LocalServer _instance = LocalServer._internal();
  factory LocalServer() => _instance;
  LocalServer._internal();

  HttpServer? _server;
  bool get isRunning => _server != null;

  Future<void> start() async {
    if (_server != null) return;
    final router = Router();

    // Rotta base
    router.get('/', (Request request) {
      return Response.ok('Server Flutter attivo!');
    });

    // Rotta con parametri dinamici
    router.get('/saluta/<nome>', (Request request, String nome) {
      return Response.ok('Ciao, $nome!');
    });

    // Pipeline con middleware (es. logging)
    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    // Avvio del server sull'IP locale (0.0.0.0 lo rende visibile in rete locale)
    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
    print('Server in ascolto su http://${_server!.address.address}:${_server!
        .port}');
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    print('Server spento.');
  }
}