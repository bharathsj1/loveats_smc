import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:potbelly/Flip_nav_bar/demo.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/screens/root_screen2.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/vendor_screens.dart/Home_screen.dart';
import 'package:potbelly/widgets/snackbar.dart';
import './ProviderService.dart';
import 'package:provider/provider.dart';
import 'side.dart';
import 'sun_moon.dart';

import 'gooey_edge.dart';
import 'gooey_edge_clipper.dart';

// int pageindex = 0;
// int dragIndex;
// Offset dragOffset;
// double dragDirection;
// bool dragCompleted;

// GooeyEdge _edge;
Ticker _ticker;
GlobalKey _key = GlobalKey();

class GooeyCarousel extends StatefulWidget {
  final List<Widget> children;

  GooeyCarousel({@required this.children}) : super();

  @override
  GooeyCarouselState createState() => GooeyCarouselState();
}

class GooeyCarouselState extends State<GooeyCarousel>
    with SingleTickerProviderStateMixin {
  int _currentIndex;
  @override
  void initState() {
    // Provider.of(context, listen: false)._edge = GooeyEdge(count: 25);
    _ticker = createTicker(_tick)..start();
    super.initState();
  }

  check() {}

  @override
  void dispose() {
    _ticker.dispose();

    super.dispose();
  }

  void _tick(Duration duration) {
    Provider.of<ProviderService>(context, listen: false).edge.tick(duration);
    setState(() {});
  }

  // changgeindex(i) {
  //   pageindex = i;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    int l = widget.children.length;
    return Consumer<ProviderService>(builder: (context, service, child) {
      return GestureDetector(
          key: _key,
          onPanDown: (details) =>
              Provider.of<ProviderService>(context, listen: false)
                  .handlePanDown(details, _getSize()),
          onPanUpdate: (details) =>
              Provider.of<ProviderService>(context, listen: false)
                  .handlePanUpdate(details, _getSize()),
          onPanEnd: (details) =>
              Provider.of<ProviderService>(context, listen: false)
                  .handlePanEnd(details, _getSize()),
          child: Stack(
            children: <Widget>[
              widget.children[service.pageindex % l],
              service.dragIndex == null
                  ? SizedBox()
                  : ClipPath(
                      child: widget.children[service.dragIndex % l],
                      clipBehavior: Clip.hardEdge,
                      clipper: GooeyEdgeClipper(service.edge, margin: 10.0),
                    ),
              SunAndMoon(
                index: service.dragIndex,
                isDragComplete: service.dragCompleted,
              ),
              service.ind % 3 == 2
                  ? service.login || service.signup
                      ? Container()
                      : Positioned(
                          bottom: 64,
                          left: 50,
                          right: 50,
                          child: Container(
                            // color: Colors.green.withOpacity(0.8),
                            color: Colors.transparent,

                            height: 55,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: InkWell(
                              onTap: () {
                                print('login');
                                Provider.of<ProviderService>(context,
                                        listen: false)
                                    .changeslogtatus();
                                bottomsheet();
                                // Provider.of<ProviderService>(context, listen: false)
                                //     .handlePanUpdate(
                                //         DragUpdateDetails(
                                //             globalPosition: Offset(-100.0, 10.0)),
                                //         Size(150.0, 20.0));
                              },
                            ),
                          ))
                  : Positioned(
                      bottom: 62,
                      left: 50,
                      right: 50,
                      child: Container(
                        // color: Colors.red.withOpacity(0.4),
                        color: Colors.transparent,
                        height: 52,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: InkWell(
                          onTap: () {
                            print('hello');
                            Provider.of<ProviderService>(context, listen: false)
                                .handlePanUpdate(
                                    DragUpdateDetails(
                                        globalPosition: Offset(-100.0, 10.0)),
                                    Size(150.0, 20.0));
                          },
                        ),
                      )),
            ],
          ));
    });
    // );
  }

  Size _getSize() {
    final RenderBox box = _key.currentContext.findRenderObject();
    return box.size;
  }

  bottomsheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        
        backgroundColor: Colors.white.withOpacity(0.3),
        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            // side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0))),
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ClipRRect(
                borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0)),
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                
                  child: new Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    color: Colors
                        .white.withOpacity(0.2), //could change this to Color(0xFF737373),
                    //so you don't have to change MaterialApp canvasColor
                    //   child: new Container(
                    //       decoration: new BoxDecoration(
                    //           color: Colors.transparent,
                    //           borderRadius: new BorderRadius.only(
                    //               topLeft: const Radius.circular(30.0),
                    //               topRight: const Radius.circular(30.0))),
                    //       child: new Center(
                    //         child: new Text("This is a modal sheet"),
                    //       )),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                                child: Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                            )),
                            SizedBox(
                              height: 30,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 35.0),
                            //   child: Text(
                            //     'Email Address',
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 6,
                            // ),
                            Card(
                              // elevation: 5,
                              color: Colors.transparent,
                              // shape: RoundedRectangleBorder(
                              //  side: BorderSide(color: Colors.white, width: 1),
                              //     borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) => emailValidation(value),
                                    style: TextStyle(
                                        // fontFamily: "WorkSansSemiBold",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      // border: OutlineInputBorder(
                                      //     borderSide:
                                      //         BorderSide(color: Colors.white)),
                                      hintText: "Email Address",
                        
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 35.0),
                            //   child: Text(
                            //     'Password',
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 6,
                            // ),
                            Card(
                              // elevation: 5,
                              color: Colors.transparent,
                              // shape: RoundedRectangleBorder(
                              //  side: BorderSide(color: Colors.white, width: 1),
                              //     borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white,
                                  ),
                                  child: TextFormField(
                                    // focusNode: myFocusNodePassword,
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) => passwordValidation(value),
                                    obscureText: true,
                                    style: TextStyle(
                                        // fontFamily: "WorkSansSemiBold",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      // border: OutlineInputBorder(
                                      //     borderSide:
                                      //         BorderSide(color: Colors.white)),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(builder: (_) => RootScreen()),
                                  //     (route) => false);
                                  _signInWithEmail(context, emailController,
                                      passwordController, _formKey);
                                },
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                  // shape: RoundedRectangleBorder(
                                  //   side: BorderSide(width: 1,color: AppColors.black,),
                                  // ),
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: AppColors.black,
                                        // border: Border.all(width: 1,color: AppColors.black),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Platform.isIOS
                                    ? InkWell(
                                      onTap: (){
                                        _signInWithApple(context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 10),
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.apple,
                                            color: Colors.black,
                                            size: 28,
                                          ),
                                          // child: Image.asset('assets/images/apple.png',height: 30,width: 30,),
                                        ),
                                    )
                                    : Container(),
                                Platform.isIOS
                                    ? SizedBox(
                                        width: 50,
                                      )
                                    : Container(),
                                InkWell(
                                  onTap: () {
                                    _signInWithGoogle(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: new Icon(
                                      FontAwesomeIcons.google,
                                      color: Color(0xFFEA4335),
                                    ),
                                  ),
                                ),
                                // Icon(FontAwesomeIcons.applePay)
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "I'm new user. ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      newemailController.text='';
                                      uid=null;
                                      type=null;
                                            setState(() {});
                                      bottomsheet2();
                                      Provider.of<ProviderService>(context,
                                              listen: false)
                                          .changessignuptatus();
                                      print(Provider.of<ProviderService>(context,
                                              listen: false)
                                          .login);
                                      print(Provider.of<ProviderService>(context,
                                              listen: false)
                                          .signup);
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: AppColors.secondaryElement,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
          
        }).whenComplete(() {
      print('here');
      Provider.of<ProviderService>(context, listen: false).allfalse();
    });
  }

  bottomsheet2() {
    return showModalBottomSheet(
        // elevation: 5,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white.withOpacity(0.4),
        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            // side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  ClipRRect(
                borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0)),
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: new Container(
                    height: MediaQuery.of(context).size.height / 2,
                    color: Colors.white.withOpacity(0.2),
                    // color: Colors.transparent,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                                child: Text(
                              "Create Account",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )),
                            SizedBox(
                              height: 30,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 35.0),
                            //   child: Text(
                            //     'Full Name',
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 6,
                            // ),
                            Card(
                              // elevation: 5,
                              color: Colors.transparent,
                              // shape: RoundedRectangleBorder(
                              //  side: BorderSide(color: Colors.white, width: 1),
                              //     borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white,
                                  ),
                                  child: TextFormField(
                                    // focusNode: myFocusNodeEmailLogin,
                                    controller: fullnameController,
                                    keyboardType: TextInputType.name,
                                    validator: (value) => nameValidator(value),
                                    style: TextStyle(
                                        // fontFamily: "WorkSansSemiBold",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      // border: OutlineInputBorder(
                                      //     borderSide:
                                      //         BorderSide(color: Colors.white)),
                                      hintText: "Full Name",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 35.0),
                            //   child: Text(
                            //     'Phone Number',
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 6,
                            // ),
                            Card(
                              // elevation: 5,
                              color: Colors.transparent,
                              // shape: RoundedRectangleBorder(
                              //  side: BorderSide(color: Colors.white, width: 1),
                              //     borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white,
                                  ),
                                  child: TextFormField(
                                    // focusNode: myFocusNodeEmailLogin,
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) => phoneValidator(value),
                                    style: TextStyle(
                                        // fontFamily: "WorkSansSemiBold",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      // border: OutlineInputBorder(
                                      //     borderSide:
                                      //         BorderSide(color: Colors.white)),
                                      hintText: "Phone Number",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 35.0),
                            //   child: Text(
                            //     'Email Address',
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 6,
                            // ),
                            Card(
                              // elevation: 5,
                              color: Colors.transparent,
                              // shape: RoundedRectangleBorder(
                              //  side: BorderSide(color: Colors.white, width: 1),
                              //     borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white,
                                  ),
                                  child: TextFormField(
                                    // focusNode: myFocusNodeEmailLogin,
                                    controller: newemailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) => emailValidation(value),
                                    style: TextStyle(
                                        // fontFamily: "WorkSansSemiBold",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      // border: OutlineInputBorder(
                                      //     borderSide:
                                      //         BorderSide(color: Colors.white)),
                                      hintText: "Email Address",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 35.0),
                            //   child: Text(
                            //     'Password',
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 6,
                            // ),
                            Card(
                              // elevation: 5,
                              color: Colors.transparent,
                              // shape: RoundedRectangleBorder(
                              //  side: BorderSide(color: Colors.white, width: 1),
                              //     borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white,
                                  ),
                                  child: TextFormField(
                                    // focusNode: myFocusNodeEmailLogin,
                                    controller: newpasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) => passwordValidation(value),
                                    obscureText: true,
                                    style: TextStyle(
                                        // fontFamily: "WorkSansSemiBold",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      // border: OutlineInputBorder(
                                      //     borderSide:
                                      //         BorderSide(color: Colors.white)),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (_) => BubbleTabBarDemo(type: '2')),
                                  //     (route) => false);
                                  validateFormAndCreateUser(context);
                                },
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                  // shape: RoundedRectangleBorder(
                                  //   side: BorderSide(width: 1,color: AppColors.black,),
                                  // ),
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: AppColors.black,
                                        // border: Border.all(width: 1,color: AppColors.black),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       "I'm new user. ",
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.w400),
                            //     ),
                            //     Text(
                            //       "Sign Up",
                            //       style: TextStyle(
                            //           color: AppColors.secondaryElement,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        }).whenComplete(() {
      print('here');
      Provider.of<ProviderService>(context, listen: false).changeslogtatus();
      Provider.of<ProviderService>(context, listen: false).allfalse();
    });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newemailController = TextEditingController();
  final newpasswordController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();

  emailValidation(String value) {
    if (value.isEmpty)
      return 'Email is required';
    else if (!value.contains('@')) return 'Invalid Email';
  }

  passwordValidation(String value) {
    if (value.isEmpty)
      return 'Password is required';
    else if (value.length < 8) return 'Password is wrong';
  }

  nameValidator(String value) {
    if (value.isEmpty)
      return 'Name field is required';
    else if (value.length < 3) return 'Please enter valid name';
  }

  phoneValidator(String value) {
    if (value.isEmpty)
      return 'Phone number is required';
    else if (value.length < 10) return 'Invalid PHone Number';
  }

  _signInWithApple(BuildContext context) async {
    String message = await Service().signInWithApple();
    print(message);

    if (message.contains('successfully')) {
      var type = await AppService().gettype();
      var udid;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        udid = androidInfo.id;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        udid = iosInfo.identifierForVendor;
      }
      _firebaseMessaging.getToken().then((tokeen) {
        var data = {'device_id': udid, 'firebase_token': tokeen};
        AppService().savedeicetoken(data).then((value) {
          print(value);
          Navigator.pop(context);
          Provider.of<ProviderService>(context, listen: false).allfalse();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => 
                  // BubbleTabBarDemo(type: type,)
                   type == '2'? HomeScreen():  Vendor_Home_screen()
                  ),
              (route) => false);
        });
      });
    } else if (message.contains('register screen')) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      var currUser = _auth.currentUser;
      Navigator.pop(context);
      newemailController.text = currUser.email;
      uid = currUser.uid;
      type = 2;
      setState(() {});
      bottomsheet2();

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => RegisterScreen(
      //         email: currUser.email,
      //          uid: currUser.uid,
      //          type: 2,
      //       ),
      //     ),
      //     (route) => false);
    } else
      showSnackBar(context, message);
  }

  _signInWithEmail(BuildContext context, TextEditingController emailCont,
      TextEditingController passwordCont, key) async {
    if (key.currentState.validate()) {
      var response = await Service()
          .signInWithEmail(context, emailCont.text, passwordCont.text);
      if (response['message'].contains('success')) {
        var udid;
        print(response['user']);
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          udid = androidInfo.id;
        } else {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          udid = iosInfo.identifierForVendor;
        }
        _firebaseMessaging.getToken().then((tokeen) {
          var data = {'device_id': udid, 'firebase_token': tokeen};
          AppService().savedeicetoken(data).then((value) {
            print(value);
            Navigator.pop(context);
            Provider.of<ProviderService>(context, listen: false).allfalse();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) =>  
                    // BubbleTabBarDemo(type: response['user'].data.custAccountType)
                    response['user'].data.custAccountType == '2'? HomeScreen():  Vendor_Home_screen()
                        ),
                (route) => false);
          });
        });
      } else
        showSnackBar(context, response['message']);
    }
  }

  _signInWithGoogle(BuildContext context) async {
    String message = await Service().signInWithGoogle();
    print(message);

    if (message.contains('successfully')) {
      var type = await AppService().gettype();
      var udid;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        udid = androidInfo.id;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        udid = iosInfo.identifierForVendor;
      }
      _firebaseMessaging.getToken().then((tokeen) {
        var data = {'device_id': udid, 'firebase_token': tokeen};
        AppService().savedeicetoken(data).then((value) {
          Navigator.pop(context);
          Provider.of<ProviderService>(context, listen: false).allfalse();

          print(value);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) =>  
                  // BubbleTabBarDemo(type: type)
                  type == '2'? HomeScreen():  Vendor_Home_screen()
                  ),
              (route) => false);
        });
      });
    } else if (message.contains('register screen')) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      var currUser = await _auth.currentUser;
      print(currUser.uid);
      Navigator.pop(context);
      newemailController.text = currUser.email;
      uid = currUser.uid;
      type = 1;
      setState(() {});
      bottomsheet2();

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => RegisterScreen(
      //         email: currUser.email,
      //         uid: currUser.uid,
      //         type: 1,
      //       ),
      //     ),
      //     (route) => false);
    } else
      showSnackBar(context, message);
  }

  var uid;
  Service _service = Service();
  File _profilePicture;
  int type;

  void validateFormAndCreateUser(
    BuildContext context,
  ) async {
    print('In Validating form section');

    // if (_formKey.currentState.validate()) {
      UserModel userModel = UserModel(
          '',
          fullnameController.text,
          newemailController.text,
          newpasswordController.text,
          phoneController.text,
          '');
      // String uid = uid;
      print(uid);
      var message = await _service.registerUserWithEmail(
          userModel, _profilePicture, uid, type ?? 0);
      print(message);
      if (message == 'success') {
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
        var udid;
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          udid = androidInfo.id;
        } else {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          udid = iosInfo.identifierForVendor;
        }
        _firebaseMessaging.getToken().then((tokeen) {
          var data = {'device_id': udid, 'firebase_token': tokeen};
          AppService().savedeicetoken(data).then((value) {
            print(value);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => 
                // BubbleTabBarDemo(type: '2')
                HomeScreen()
                ),
                (route) => false);
          });
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => 
            // BubbleTabBarDemo(type: '2')
            HomeScreen()
            ));
      } else {
        showSnackBar(context, message);
      }
    // } else {
    //   print('Not Validate');
    // }
  }
}
