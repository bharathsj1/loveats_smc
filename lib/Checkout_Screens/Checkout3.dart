import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

class CheckOutScreen3 extends StatefulWidget {
    var checkoutdata;
  CheckOutScreen3({@required this.checkoutdata});

  @override
  _CheckOutScreen3State createState() => _CheckOutScreen3State();
}

class _CheckOutScreen3State extends State<CheckOutScreen3> {
  Widget createrow(color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.radio_button_checked_rounded,
                color: color,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 100,
                // color: Colors.red,
                child: Row(
                  children: List.generate(
                      200 ~/ 10,
                      (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey,
                              height: 2,
                            ),
                          )),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 5,
        // ),
        // Text(
        //   'Delivery address',
        //   style: TextStyle(color: AppColors.secondaryElement, fontSize: 12),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.headingText,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: widget.checkoutdata['type'] =='subscription'?null: Text(
          'Order Placed',
          style: Styles.customTitleTextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w500,
            fontSize: Sizes.TEXT_SIZE_20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          //  widget.checkoutdata['type'] =='subscription'? Container(): Material(
          //     elevation: 0.5,
          //     child: Container(
          //       height: 60,
          //       color: AppColors.white,
          //       // padding: EdgeInsets.only(top: 12),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           createrow(AppColors.grey),
          //           Container(
          //               margin: EdgeInsets.only(left: 5),
          //               child: createrow(AppColors.grey)),
          //           SizedBox(
          //             width: 8,
          //           ),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(left: 5.0),
          //                 child: Row(
          //                   children: [
          //                     Icon(
          //                       Icons.radio_button_checked_rounded,
          //                       color: AppColors.secondaryElement,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               // SizedBox(
          //               //   height: 5,
          //               // ),
          //               // Text(
          //               //   'Delivery address',
          //               //   style: TextStyle(
          //               //       color: AppColors.secondaryElement, fontSize: 12),
          //               // ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
            SizedBox(
              height: 70,
            ),
           widget.checkoutdata['type'] =='subscription'? Center(child: Image.asset('assets/images/congras.gif')): Image.asset('assets/images/cooking.gif'),
            SizedBox(
              height: 35,
            ),
            Center(
              child: Text(widget.checkoutdata['type'] =='subscription'? 'Subscription Activated Successfully': 'Order Placed Successfully',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'roboto')),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Text(widget.checkoutdata['type'] =='subscription'? 'Congratulations! Subscription has been activated to your account, Enjoy! ': 'Congratulations! Your order has been placed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      
                        color: Colors.black54,
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'roboto')),
              ),
            ),
         widget.checkoutdata['type'] =='subscription'?Container():   Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You can track your order number',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                          fontFamily: 'roboto')),
                          SizedBox(width: 5,),
                  Text('#'+widget.checkoutdata['orderId'].toString(),
                      style: TextStyle(
                          color: AppColors.secondaryElement,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'roboto')),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              //  PotbellyButton(
              //   'Continue Shopping',
              //   onTap: () {
              //     AppRouter.navigator.pushNamed(AppRouter.CheckOut2);
              //   },
              //   buttonHeight: 45,
              //   buttonWidth:  MediaQuery.of(context).size.width/2.5,
              //   buttonTextStyle: TextStyle(
              //       fontSize: 16,
              //       fontFamily: 'roboto',
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(6),
              //       color: AppColors.grey),
              // ),
              // SizedBox(width: 10,),
               PotbellyButton(
              widget.checkoutdata['type'] =='subscription'? 'Continue' : 'Continue',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,AppRouter.homeScreen, (route) => false);
                },
                buttonHeight: 45,
                buttonWidth:  MediaQuery.of(context).size.width/2.5,
                buttonTextStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.secondaryElement),
              ),
            ],)
          ],
        ),
      ),
    );
  }
}
