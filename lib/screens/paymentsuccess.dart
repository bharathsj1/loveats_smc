import 'dart:async';
import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/values.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

class PaymentSuccess extends StatefulWidget {
  var checkoutdata;
  PaymentSuccess({@required this.checkoutdata});
  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  AnimationController controller;
  final int timerMaxSeconds = 10;
  int currentSeconds = 0;
  double physicmodelelevation = 0;
  double height = 0;
  // double newheight=0;
  double width = 0;
  Timer time;
  double iconheight = 0;
  double iconwidth = 0;
  // double newwidth=0;

  void initState() {
    super.initState();
    startTimeout();

    // Timer(Duration(seconds: 5), () {
    //   //  Navigator.pop(context);
    //   AppRouter.navigator
    //       .pushNamedAndRemoveUntil(AppRouter.rootScreen, (route) => false);
    // });
  }

  startTimeout([int milliseconds]) {
    Timer(Duration(microseconds: 500), () {
      //  Navigator.pop(context);
      // AppRouter.navigator
      //     .pushNamedAndRemoveUntil(AppRouter.rootScreen, (route) => false);
      setState(() {
        height = 170;
        width = 170;
        iconheight = 130;
        iconwidth = 130;
      });
    });
    var duration = Duration(seconds: 3);
    time = Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        if (physicmodelelevation == 0) {
          physicmodelelevation = 20;
        } else {
          physicmodelelevation = 0;
        }
        // currentSeconds = timer.tick;
        // if (timer.tick >= timerMaxSeconds)
        //   timer.cancel();
        // submitDataToFirebase();
      });
    });
  }

  @override
  void dispose() {
    time.cancel();
    super.dispose();
  }

  Widget generaterow(String name, String value) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              height: 40,
              // color: Colors.red,
              width: MediaQuery.of(context).size.width * 0.83,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: AppColors.white,
      //   // leading: InkWell(
      //   //     onTap: () {
      //   //       AppRouter.navigator.pushNamedAndRemoveUntil(
      //   //           AppRouter.rootScreen, (route) => false);
      //   //     },
      //   //     child: Icon(
      //   //       Icons.home,
      //   //       color: AppColors.secondaryElement,
      //   //     )),
      //   automaticallyImplyLeading: false,
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(margin: EdgeInsets.only(top: 70),
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    height: height,
                    width: width,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                            color: AppColors.secondaryElement.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(1000)),
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.all(20),
                          color: AppColors.secondaryElement.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000)),
                          child: AnimatedPhysicalModel(
                            // animateColor: true,
                            animateShadowColor: true,
                            color: AppColors.secondaryElement.withOpacity(0.9),
                            duration: Duration(seconds: 1),
                            elevation: physicmodelelevation,
                            shadowColor: ThemeData().shadowColor,
                            shape: BoxShape.circle,
                            child: Container(
                              // padding:  EdgeInsets.all(50),

                              decoration: BoxDecoration(
                                  // color: Color(0xFF6043F5),
                                  color:
                                      AppColors.secondaryElement.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(1000)),
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height: iconheight,
                                width: iconwidth,
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 90,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'PAYMENT SUCCESSFULL',
                  style: TextStyle(
                      color: AppColors.secondaryElement,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                // Text(
                //   'Redirecting to the home page...',
                //   style: TextStyle(
                //     color: AppColors.secondaryElement,
                //     fontSize: 20,
                //     // fontWeight: FontWeight.bold
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: 5,),
                             widget.checkoutdata['type'] == 'cart'
                                  ?  generaterow('Order Id',
                                  '#' + widget.checkoutdata['orderid']):Container(),
                              
                              // generaterow('Email', widget.checkoutdata['email']),
                              generaterow('Amount', '${StringConst.currency}'+widget.checkoutdata['amount'].toString()),
                              generaterow(
                                  'Payment Id', widget.checkoutdata['paymentid']),
                              widget.checkoutdata['type'] == 'cart'
                                  ? generaterow(
                                      'Total Items',
                                      'x ' +
                                          widget.checkoutdata['cartlist'].length
                                              .toString())
                                  : Container(),
                              widget.checkoutdata['type'] == 'cart'
                                  ? generaterow(
                                      'Total Items Quantity',
                                      'x ' +
                                          widget.checkoutdata['qty'].toString())
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            height: 60,
                                            // color: Colors.red,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.83,
                                            margin: EdgeInsets.only(left: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Lovesats Suscription',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Activated',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                              generaterow(
                                'Date-Time',
                                DateFormat('hh:mm,  MMM dd, y')
                                    .format(DateTime.now()),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                PotbellyButton(StringConst.CONTINUE,
                buttonTextStyle: TextStyle(fontSize: 20,color: AppColors.white,fontWeight: FontWeight.bold),
                    buttonHeight: 50, onTap: () {
                       Navigator
            .pushNamedAndRemoveUntil(context,AppRouter.rootScreen, (route) => false);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
