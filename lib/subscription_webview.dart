import 'dart:async';

import 'package:flutter/material.dart';
import 'package:potbelly/widgets/toaster.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionWebview extends StatefulWidget {
  final String userId;
  final String planId;

  const SubscriptionWebview({Key key, this.userId, this.planId})
      : super(key: key);

  @override
  _SubscriptionWebviewState createState() => _SubscriptionWebviewState();
}

class _SubscriptionWebviewState extends State<SubscriptionWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl:
            'https://love.signaturemediachannel.com/checkout/${widget.userId}/${widget.planId}',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageStarted: (url) => print('page is started'),
        onPageFinished: (url) {
          if (url.contains('success')) {
            Navigator.pop(context);
            showToaster('Your subscription has been done successfully');
          }
        },
        onProgress: (progress) => print(progress),

        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: true,

// 4242 4242 4242 4242
// 1224
// 123
// 49000
// MOID
      ),
    );
  }
}
