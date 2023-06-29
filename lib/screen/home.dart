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
      'https://flutter.dev/?gclid=Cj0KCQjwtO-kBhDIARIsAL6LorcYgRM71l9KmkJtUVguxurLLVcxaXA-Ac9GsvO7SYyzSTgHP4f3ywoaAuolEALw_wcB&gclsrc=aw.ds';
  final String url2 = 'https://www.youtube.com/';

  late bool loading;

  late bool hasError;
  late String errorMessage;

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    hasError = false;

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
          onWebResourceError: (WebResourceError error) {
            errorMessage = ('''
            Código do Erro: ${error.errorCode}
            Descrição: ${error.description}
            Tipo de Erro: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
            ''');
            debugPrint(errorMessage);
            setState(() {
              hasError = true;
              errorMessage = errorMessage;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    debugPrint("loading $loading");
    debugPrint('error $hasError');
    controllerWebView = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View With Flutter'),
      ),
      body: hasError
          ? Center(child: Text(errorMessage))
          : loading
              ? const Center(child: CircularProgressIndicator())
              : WebViewWidget(controller: controllerWebView),
    );
  }
}
