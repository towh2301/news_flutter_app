import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url, category, title;
  const MyWebView({
    super.key,
    required this.url,
    required this.category,
    required this.title,
    required this.controller,
  });

  final WebViewController controller;

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late String _url;
  var loadingPercentage = 0;
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _url = widget.url;
    // Initialize the controller of WebView
    widget.controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
        // Add from here...
        onNavigationRequest: (navigation) {
          final host = Uri.parse(navigation.url).host;
          if (host.contains('youtube.com')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Blocking navigation to $host',
                ),
              ),
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        // ...to here.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return View
    return Stack(
      children: [
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////

class WebViewWidget extends StatefulWidget {
  final String url, category, title;

  const WebViewWidget(
      {super.key,
      required this.url,
      required this.category,
      required this.title});

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
        // Add from here...
        actions: [
          NavigationControls(controller: controller),
        ],
        // ...to here.
      ),
      body: MyWebView(
        controller: controller,
        url: widget.url,
        category: widget.category,
        title: widget.title,
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No back history item')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No forward history item')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}
