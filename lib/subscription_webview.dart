import 'dart:async';

import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/widgets/toaster.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionWebview extends StatefulWidget {
  final String userId;
  final String planId;
  final String personquantity;
  final String perweek;
  final bool isrecipe;

  const SubscriptionWebview({Key key, this.userId, this.planId,@required this.isrecipe,this.perweek,this.personquantity})
      : super(key: key);

  @override
  _SubscriptionWebviewState createState() => _SubscriptionWebviewState();
}

class _SubscriptionWebviewState extends State<SubscriptionWebview> {
  @override
  void initState() {
    print(widget.userId);
    print(widget.planId);
    print(widget.isrecipe);
    print(widget.perweek);
    print(widget.personquantity);
    super.initState();
  }
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl:
           widget.isrecipe? 'https://love.signaturemediachannel.com/checkout-subscription/${widget.userId}/${widget.planId}/${widget.personquantity}/${widget.perweek}': 'https://love.signaturemediachannel.com/checkout/${widget.userId}/${widget.planId}',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageStarted: (url) => print('page is started'),
        onPageFinished: (url) {
          if (url.contains('success')) {
            Navigator.pop(context);
            showToaster('Your subscription has been done successfully');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        // BubbleTabBarDemo(type: '2')
                        HomeScreen()),
                (route) => false);
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
