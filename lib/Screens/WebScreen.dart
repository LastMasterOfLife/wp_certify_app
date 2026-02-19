import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webscreen extends StatefulWidget {
  final String loadUrl;
  const Webscreen({super.key, required this.loadUrl});

  @override
  State<Webscreen> createState() => _WebscreenState();
}

class _WebscreenState extends State<Webscreen> {

  late final WebViewController _controller;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent('FlutterWebView/wp_app')
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              final url = request.url;

              if (url.startsWith('myapp://')) {
                final uri = Uri.parse(url);

                if (uri.host == 'open') {
                  final path = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';

                  String initialTab;
                  switch (path) {
                    case 'camera':
                      initialTab = '/camera';
                      break;
                    case 'settings':
                      initialTab = '/settings';
                      break;
                    default:
                      initialTab = '/web';
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/container',
                      arguments: {
                        'url': widget.loadUrl,
                        'initialTab': initialTab,
                      },
                    );
                  });
                }

                // Blocca la WebView dal navigare verso myapp://
                return NavigationDecision.prevent;
              }

              // Tutti gli altri URL navigano normalmente
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.loadUrl));

      _isInitialized = true;
    }
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