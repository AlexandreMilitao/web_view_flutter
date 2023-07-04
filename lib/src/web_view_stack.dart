import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final Completer<WebViewController> controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  late bool loading;
  late WebViewController controllerWebView;

  final String url = 'https://physiofrog-staging.firebaseapp.com/landing';
  // final String url =
  //     'https://flutter.dev/?gclid=Cj0KCQjwho-lBhC_ARIsAMpgMoeGlBEojumm_RLPZnpBZbw_kbwYjX-QjhUz-4cvphx02O5f-YKtKU4aAnhVEALw_wcB&gclsrc=aw.ds';
  //final String url = 'https://www.youtube.com/';

  late bool hasError;
  late String errorMessage;

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    hasError = false;

    loading = true;

    WebViewController controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(const Color(0xff000000));
    controller.loadRequest(Uri.parse(url));
    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          loadingPercentage = progress;
        },
        onPageStarted: (
          String url,
        ) {
          widget.controller.complete(controllerWebView);
        },
        onPageFinished: (
          String url,
        ) {
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
          loadingPercentage = 0;
        },
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(url)) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    controller.loadRequest(Uri.parse(url));
    controllerWebView = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        hasError
            ? Center(child: Text(errorMessage))
            : loading
                ? const Center(child: CircularProgressIndicator())
                : WebViewWidget(controller: controllerWebView),
      ],
    );
  }
}
