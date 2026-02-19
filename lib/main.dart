import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:wp_app/Screens/CameraScreen.dart';
import 'package:wp_app/Screens/ContainerScreen.dart';
import 'package:wp_app/Screens/LoginScreen.dart';
import 'package:wp_app/Screens/RegisterScreen.dart';
import 'package:wp_app/Screens/SettingsScreen.dart';
import 'package:wp_app/Screens/WebScreen.dart';

import 'Services/ConnectionService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String _pendingRoute = '/'; // default: LoginScreen

  @override
  void initState() {
    super.initState();
    ConnectionService().initialize();
    _handleInitialLink();
    _handleIncomingLinks();
  }

  ///
  /// App chiusa quando è arrivato il link
  ///
  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _processLink(uri);
      }
    } catch (e) {
      debugPrint('Errore initial link: $e');
    }
  }

  ///
  /// App in background o foreground quando è arrivato il link
  ///
  void _handleIncomingLinks() {
    _appLinks.uriLinkStream.listen(
          (uri) {
        _processLink(uri);
      },
      onError: (e) {
        debugPrint('Errore stream link: $e');
      },
    );
  }

  void _processLink(Uri uri) {
    // myapp://open/camera → apre CameraScreen dopo il login
    if (uri.host == 'open') {
      final path = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
      switch (path) {
        case 'camera':
          setState(() => _pendingRoute = '/camera');
          break;
        case 'settings':
          setState(() => _pendingRoute = '/settings');
          break;
        case 'web':
          setState(() => _pendingRoute = '/web');
          break;
        default:
          setState(() => _pendingRoute = '/container');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Loginscreen(redirectTo: _pendingRoute),
        '/container': (context) => Containerscreen(),
        '/web': (context) => Webscreen(loadUrl: 'https://google.com'),
        '/signup': (context) => Registerscreen(),
        '/camera': (context) => CameraScreen(url: 'https://google.com'),
        '/settings': (context) => Settingsscreen(),
      },
    );
  }
}