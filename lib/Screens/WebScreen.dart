import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


///
/// Schermata che mostra una Web
///
class Webscreen extends StatefulWidget {
  final String loadUrl;
  const Webscreen({super.key, required this.loadUrl});

  @override
  State<Webscreen> createState() => _WebscreenState();
}

///
/// _controller viene usato per gestire e mostrare la pagina web
///
class _WebscreenState extends State<Webscreen> {

  late final WebViewController _controller;
  bool _isInitialized = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      //final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      //final String loadUrl = args['url'] ?? 'https://www.google.com';

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.loadUrl));

      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}