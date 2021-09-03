import 'dart:io';

import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final dynamic url;

  WebViewPage({Key key, @required this.url});
  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  var _loading = true;
  var _progressValue = 0.1;
  num position = 1;
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          // title: Text(widget.url, style: TextStyle(color: Colors.black, fontSize: 18),),
          elevation: 0.0,
        ),
        body: IndexedStack(index: position, children: <Widget>[
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
             onPageStarted: (value){setState(() {
                          position = 1;
                        });},
            onProgress: (int progress) {
              
              print("WebView is loading (progress : $progress%)");
              _progressValue = progress / 100;
              setState(() {});
            },

             onPageFinished: (value){setState(() {
                          position = 0;
                        });},
        
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
          ),
          LinearProgressIndicator(
            backgroundColor: Colors.grey.shade300,
            valueColor:
                new AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
            value: _progressValue,
          ),
        ])
        );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
