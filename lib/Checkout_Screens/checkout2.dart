import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/paymentservice.dart';
import 'package:potbelly/values/values.dart';
import 'package:toast/toast.dart';
// import 'package:potbelly/widgets/potbelly_button.dart';

class CheckOutScreen2 extends StatefulWidget {
  var checkoutdata;
  CheckOutScreen2({@required this.checkoutdata});

  @override
  _CheckOutScreen2State createState() => _CheckOutScreen2State();
}

class _CheckOutScreen2State extends State<CheckOutScreen2> {
  var selectedmethod = 0;
  bool isSwitched = false;
  var _paymentSheetData;
  double total;
  bool loader=false;

  @override
  void initState() {
    print(widget.checkoutdata['cartlist'].length);
    total = widget.checkoutdata['total'] +
        widget.checkoutdata['shipping'] +
        widget.checkoutdata['charges'];
    super.initState();
  }



  paynow() async {
    this.loader = true;
    setState(() {});
    print(total.floor());
    var data = {
      'amount': (total.floor()).toString() + '00',
      'currency': 'usd',
      // 'receipt_email': 'miansaadhafeez@gmail.com'
    };
    PaymentService().getIntent(data).then((value) async {
      print(value);
      
      if (value == 'Error in payment') {
        Toast.show('Error in payment', context, duration: 3);
      } else {
        _paymentSheetData = value;
        setState(() {});
        try {
          // intent=await  Stripe.instance.retrievePaymentIntent(_paymentSheetData['client_secret']);
          //  print(intent);
          setState(() {});
          await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: _paymentSheetData['client_secret'],
            // customerEphemeralKeySecret: _paymentSheetData['ephemeralKey'],
            // customerId: _paymentSheetData['customer'],
            applePay: true,
            googlePay: true,
            merchantCountryCode: 'US',
            // merchantDisplayName: 'saad',
            // style:  ThemeMode.dark,
          ));
          setState(() {});
          displayPayment();
        } catch (error) {
          print(error);
        }
      }
    });
  }

  Future<void> displayPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: _paymentSheetData['client_secret'],
              confirmPayment: true));
      setState(() {});
      var orderId='';
      print('mix');
      print(widget.checkoutdata['mixmatch']);
      if(widget.checkoutdata['mixmatch'] == true){
         var data={
        'total_amount': widget.checkoutdata['total'],
        'payment_method':'card',
        'payment_id':_paymentSheetData['client_secret'],
        'customer_addressId': widget.checkoutdata['customer_addressId'],
      };
      AppService().addeorder(data).then((value) {
      orderId= value['data']['id'];
        print(value);
        for (var i = 0; i < widget.checkoutdata['cartlist'].length; i++) {
          for (var j = 0; j < widget.checkoutdata['cartlist'][i].length; j++) {
            print(widget.checkoutdata['cartlist'][i][j]);
              var data2={
        'quantity': widget.checkoutdata['cartlist'][i][j]['qty'],
        'total_price':  widget.checkoutdata['cartlist'][i][j]['payableAmount'],
        'order_id': value['data']['id'],
        'rest_menuId': widget.checkoutdata['cartlist'][i][j]['id'],
        'rest_Id': widget.checkoutdata['cartlist'][i][j]['restaurantId'],
      };
       AppService().addorderdetails(data2).then((value) {
         print(value);
          if(i ==  widget.checkoutdata['cartlist'].length-1 && j == widget.checkoutdata['cartlist'][i].length-1){
             var data={
               'title':'New Order',
               'body': 'User has been placed a new order',
               'data':value.toString(),
              //  ''
             };
             AppService().sendnotisuperadmin(data);
             Navigator.of(context).pop();
           Navigator.of(context).pop();
             this.loader = false;
            
      setState(() {});
           Navigator.pushNamed(context,AppRouter.CheckOut3, arguments: {
        'type': widget.checkoutdata['type'],
        'orderId': orderId
      });
         }
       });
          }
        }
      //    AppRouter.navigator.pushNamed(AppRouter.CheckOut3, arguments: {
      //   'type': widget.checkoutdata['type'],
      //   'orderId': orderId
      // });
        });
      }
      else{
        for (var i = 0; i < widget.checkoutdata['cartlist'].length; i++) {
             var data={
        'total_amount': widget.checkoutdata['total'],
        'payment_method':'card',
        'payment_id':_paymentSheetData['client_secret'],
        'customer_addressId': widget.checkoutdata['customer_addressId'],
      };
      AppService().addeorder(data).then((value) {
        orderId= value['data']['id'].toString() ;
        print(orderId);
          for (var j = 0; j < widget.checkoutdata['cartlist'][i].length; j++) {
            print(widget.checkoutdata['cartlist'][i][j]);
              var data2={
        'quantity': widget.checkoutdata['cartlist'][i][j]['qty'],
        'total_price':  widget.checkoutdata['cartlist'][i][j]['payableAmount'],
        'order_id': value['data']['id'],
        'rest_menuId': widget.checkoutdata['cartlist'][i][j]['id'],
        'rest_Id': widget.checkoutdata['cartlist'][i][j]['restaurantId'],

      };
      print(data2);
       AppService().addorderdetails(data2).then((value) {
         print(value);
         if(i ==  widget.checkoutdata['cartlist'].length-1 && j == widget.checkoutdata['cartlist'][i].length-1){
             this.loader = false;
             var data={
               'title':'New Order',
               'body': 'User has been placed a new order',
               'data':value.toString(),
              //  ''
             };
             AppService().sendnotisuperadmin(data);
           Navigator.of(context).pop();
           Navigator.of(context).pop();
            this.loader = false;

      setState(() {});
           Navigator.pushNamed(context,AppRouter.CheckOut3, arguments: {
        'type': widget.checkoutdata['type'],
        'orderId': orderId
      });
         }
       });
          }
          });
        }
        
      }
     
      Toast.show('Payment Success', context, duration: 3);
    } catch (error) {
      print(error);
    }
  }

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

  List<Widget> paymentcard() {
    return List.generate(
        1,
        (index) => InkWell(
              onTap: () {
                setState(() {
                  selectedmethod = index;
                });
              },
              child: Material(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: selectedmethod == index
                          ? AppColors.secondaryElement
                          : AppColors.grey,
                      width: selectedmethod == index ? 1 : 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: selectedmethod == index
                    ? AppColors.secondaryElement.withOpacity(0.2)
                    : null,
                
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.credit_card_outlined,
                                  color: selectedmethod == index
                                      ? AppColors.secondaryElement
                                      : AppColors.black,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Credit Card',
                                  style: TextStyle(
                                      color: selectedmethod == index
                                          ? AppColors.secondaryElement
                                          : AppColors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'roboto'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            selectedmethod == index
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: AppColors.secondaryElement,
                                  )
                                : Container()
                          ],
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Text(
                        //   'Mian Saad Hafeez',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 16,
                        //       color: AppColors.black,
                        //       fontFamily: 'roboto'),
                        // ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Text(
                        //   '+921235235523',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 16,
                        //       color: AppColors.black,
                        //       fontFamily: 'roboto'),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Secure checkout payments',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontFamily: 'roboto'),
                            ),
                            Image.asset(
                              'assets/images/cards.png',
                              height: 30,
                              width: 50,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.headingText,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Checkout (2/3)',
          style: Styles.customTitleTextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w500,
            fontSize: Sizes.TEXT_SIZE_20,
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5,
        child: Container(
          color: AppColors.white,
          margin: EdgeInsets.only(top: 5),
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             loader?  Padding(
          padding: const EdgeInsets.only(bottom:8.0),
          child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            ),
        ): InkWell(
                onTap: () {
                  // AppRouter.navigator.pushNamed(AppRouter.CheckOut3);
                   paynow();
                  print(widget.checkoutdata['cartlist']);
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.89,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.secondaryElement),
                  child:   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Place Order',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                       '\$'+ total.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 0.5,
              child: Container(
                height: 60,
                color: AppColors.white,
                // padding: EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createrow(AppColors.grey),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        child: createrow(AppColors.secondaryElement)),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.radio_button_checked_rounded,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Text(
                        //   'Delivery address',
                        //   style: TextStyle(
                        //       color: AppColors.secondaryElement, fontSize: 12),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Select a payment method',
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'roboto'),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Column(children: paymentcard()),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              color: AppColors.grey,
            ),
            widget.checkoutdata['cartlist'].length > 1
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        isSwitched
                            ? Icon(
                                Icons.check_circle_outline_outlined,
                                color: AppColors.secondaryElement,
                                size: 35,
                              )
                            : Container(),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Switch to Self-Pick up?',
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'roboto')),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                  'Save the extra delivery fee if you can pick-up your order(s)',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold,
                                      fontFamily: 'roboto'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            widget.checkoutdata['cartlist'].length > 1
                ? Container()
                : Material(
                  elevation: 1,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  widget.checkoutdata['cartlist'][0][0]
                                      ['restaurantdata']['rest_image'],
                                  loadingBuilder: (BuildContext ctx, Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Container(
                                        // height: ,
                                        width: 30,
                                        height: 30,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.secondaryElement),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  fit: BoxFit.cover,
                                  height: 30,
                                  width: 30,
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      widget.checkoutdata['cartlist'][0][0]
                                          ['restaurantdata']['rest_name'],
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'roboto')),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                      widget.checkoutdata['cartlist'][0][0]
                                          ['restaurantdata']['rest_address'],
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: 'roboto')),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.pin_drop_outlined,
                                        color: AppColors.black,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                          widget.checkoutdata['cartlist'][0][0]
                                                  ['restaurantdata']['rest_city'] +
                                              ', ' +
                                              widget.checkoutdata['cartlist'][0]
                                                      [0]['restaurantdata']
                                                  ['rest_country'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'roboto')),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Spacer(),
                            Center(
                              child: Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    if(value == true){
                                      total-=widget.checkoutdata['shipping'];
                                    }
                                    print(isSwitched);
                                  });
                                },
                                activeTrackColor: AppColors.secondaryElement,
                                activeColor: AppColors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                )
          ],
        ),
      ),
    );
  }
}
