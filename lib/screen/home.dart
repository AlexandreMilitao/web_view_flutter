import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late WebViewController controllerWebView;

  final String url =
      'https://flutter.dev/?gclid=Cj0KCQjwtO-kBhDIARIsAL6Lord8mVgudUxUJmXzZre-qlpiu7ltgSAqKoT8tIKiQ82YuKGRJi58v0YaAmt3EALw_wcB&gclsrc=aw.ds';
  final String url2 = 'https://www.youtube.com/';

  late bool loading;

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    loading = true;

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xff000000))
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            loadingPercentage = progress;
            debugPrint(' $progress');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (loadingPercentage == 100) {
              setState(() {
                loading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    print("$loading");
    controllerWebView = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View With Flutter'),
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) : WebViewWidget(controller: controllerWebView),
    );
  }
}
