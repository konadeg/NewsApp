import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsViews extends StatefulWidget {

  String uri;
 NewsViews({required this.uri});

  @override
  State<NewsViews> createState() => _NewsViewsState();
}

class _NewsViewsState extends State<NewsViews> {
  final Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor:   Color.fromARGB(255, 15, 25, 1),
        title: Text("Food Recipe Webview",
        style: TextStyle(
          
        ),
        
        ),
      ),
      body: Container(
        child: WebView(
          initialUrl:widget.uri,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController WebViewController){
            setState(() {
              controller.complete(WebViewController);
            });
          },

        ),
      ),
    );
  }
}