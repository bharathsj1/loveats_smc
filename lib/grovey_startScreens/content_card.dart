import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import './ProviderService.dart';
import 'package:provider/provider.dart';
import 'gooey_carousel.dart';

class ContentCard extends StatefulWidget {
  final String color;
  final Color altColor;
  final String title;
  final String subtitle;
  String buttontext = '';

  ContentCard(
      {this.color,
      this.title = "",
      this.subtitle,
      this.altColor,
      this.buttontext})
      : super();

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  Ticker _ticker;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;
  bool login = false;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _ticker = Ticker((d) {
      setState(() {});
    })
      ..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var time = DateTime.now().millisecondsSinceEpoch / 2000;
    var scaleX = 1.2 + sin(time) * .05;
    var scaleY = 1.2 + cos(time) * .07;
    var offsetY = 20 + cos(time) * 20;
    return Consumer<ProviderService>(builder: (context, service, child) {
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Transform(
            transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
            child: Transform.translate(
              offset: Offset(-(scaleX - 1) / 2 * size.width,
                  -(scaleY - 1) / 2 * size.height + offsetY),
              child: Image.asset(
                'assets/grovey/Bg-${widget.color}.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 75.0, bottom: 25.0),
              child: Column(
                children: <Widget>[
                  //Top Image
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: widget.color == 'Red'
                          ? Lottie.asset(
                              // 'assets/Loveats_change20.json',
                              'assets/login2.json',
                              // 'assets/food2.json',
                              // 'assets/food3.json',
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              'assets/grovey/Illustration-${widget.color}.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),

                  //Slider circles
                  service.login || service.signup
                      ? Container()
                      : Container(
                          height: 14,
                          child: Image.asset(
                            'assets/grovey/Slider-${widget.color}.png',
                          )),

                  //Bottom content
                  Expanded(
                    flex: 2,
                    child: service.login || service.signup
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: _buildBottomContent(),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //         bottom: 0,
          //       child: AnimatedOpacity(
          //       opacity:  login? 1:0.0,
          //       duration: Duration(milliseconds: 500),
          //       child: login? Container(
          //         decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(0.5),

          //         // gradient: new LinearGradient(
          //         //     colors: [
          //         //       Color(0xFFfbab66),
          //         //       Color(0xFFf7418c)
          //         //     ],
          //         //     begin: const FractionalOffset(0.0, 0.0),
          //         //     end: const FractionalOffset(1.0, 1.0),
          //         //     stops: [0.0, 1.0],
          //         //     tileMode: TileMode.clamp),
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(30),
          //                 topRight: Radius.circular(30))),
          //         height: MediaQuery.of(context).size.height / 1.7,
          //         width: MediaQuery.of(context).size.width,
          //         child: Column(children: [
          //           Padding(
          //             padding: EdgeInsets.only(top: 20.0),
          //             child: _buildMenuBar(context),
          //           ),
          //           Expanded(
          //             flex: 2,
          //             child: PageView(
          //               controller: _pageController,
          //               onPageChanged: (i) {
          //                 if (i == 0) {
          //                   setState(() {
          //                     right = Colors.white;
          //                     left = Colors.black;
          //                   });
          //                 } else if (i == 1) {
          //                   setState(() {
          //                     right = Colors.black;
          //                     left = Colors.white;
          //                   });
          //                 }
          //               },
          //               children: <Widget>[
          //                 new ConstrainedBox(
          //                   constraints: const BoxConstraints.expand(),
          //                   child: _buildSignIn(context),
          //                 ),
          //                 new ConstrainedBox(
          //                   constraints: const BoxConstraints.expand(),
          //                   child: _buildSignUp(context),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],),
          //       )
          //                 :Container()
          //                 ),
          //     )
        ],
      );
    });
  }

  Widget _buildBottomContent() {
    return Consumer<ProviderService>(builder: (context, service, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.2,
                fontSize: 30.0,
                fontFamily: 'DMSerifDisplay',
                color: Colors.white,
              )),
          Text(widget.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'OpenSans',
                color: Colors.white,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: MaterialButton(
              elevation: 0,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              // color: widget.altColor,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(widget.buttontext,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: .8,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    )),
              ),
              onPressed: () {
                // if(service.pageindex == 1){
                //   // print(service.pageindex);
                //   print(service.pageindex);
                //   login=true;
                // }
                // else{

                Provider.of<ProviderService>(context, listen: false)
                    .handlePanUpdate(
                        DragUpdateDetails(globalPosition: Offset(-100.0, 10.0)),
                        Size(150.0, 20.0));
                //       Provider.of<ProviderService>(context, listen: false)
                // .handlePanDown(
                //          DragDownDetails (
                //            globalPosition: Offset(379.3, 442.2)),
                //       Size(150.0, 20.0));
                // Provider.of<ProviderService>(context, listen: false).
                //  check( DragUpdateDetails(
                //              globalPosition: Offset(-100.0, 10.0)));
                // Provider.of<ProviderService>(context, listen: false)
                //     .handlePanEnd(
                //              DragEndDetails(
                //                velocity : Velocity( pixelsPerSecond: Offset(-1204.3, 148.1))),
                //           Size(150.0, 20.0));
                // }
                print(service.pageindex);
                // setState(() {

                // });
              },
            ),
          ),
        ],
      );
    });
  }

  int i = 0;
}
