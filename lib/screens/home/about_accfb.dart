import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class AboutACCFB extends StatefulWidget {
  @override
  _AboutACCFBState createState() => _AboutACCFBState();
}

class _AboutACCFBState extends State<AboutACCFB> {
  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> _controller = Completer<WebViewController>();
    _controller.future.then((value) {
      //value.evaluateJavascript("document.body.style.zoom = \"80%\";"); //fixme
    });
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: "https://www.accfb.org/about-us/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
