import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_view_flutter/src/web_view_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'src/navigation_controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: NavigationControls(
              webViewController: controller,
            ),
          ),
          body: WebViewStack(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
