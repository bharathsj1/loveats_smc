import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/models/user.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/paymentservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:toast/toast.dart';

class CheckoutScreen extends StatefulWidget {
  var checkoutdata;
  CheckoutScreen({@required this.checkoutdata});
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int totatqty = 0;
  var _paymentSheetData;
   PaymentIntent intent;
  double total;
  bool loader = false;
  @override
  void initState() {
    total = widget.checkoutdata['total'] +
        widget.checkoutdata['shipping'] +
        widget.checkoutdata['charges'];
    if (widget.checkoutdata['type'] == 'cart') {
      calculate();
    }
    setState(() {});
    super.initState();
  }

  calculate() {
    int qty = 0;
    for (var item in widget.checkoutdata['cartlist']) {
      qty += int.parse(item['qty']);
    }
    totatqty = qty;
    setState(() {});
  }

  paynow() async {
    this.loader = true;

    bool isOrderCreated = await Service().makeOrder(total.floor());
    if (!isOrderCreated) {
      Toast.show('Server has some errors', context, duration: 3);
      return;
    }

    addOrderItemsToServer();

    setState(() {});
    print(total.floor());
    var data = {'amount': (total.floor()).toString() + '00', 'currency': 'usd'};
    PaymentService().getIntent(data).then((value) async {
      print(value);
      this.loader = false;
      setState(() {});
      if (value == 'Error in payment') {
        Toast.show('Error in payment', context, duration: 3);
      } else {
        _paymentSheetData = value;
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
          merchantDisplayName: 'saad',
          // style:  ThemeMode.dark,
        ));
        setState(() {});
        try {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: _paymentSheetData['client_secret'],

              // customerEphemeralKeySecret: _paymentSheetData['ephemeralKey'],
              // customerId: _paymentSheetData['customer'],
              applePay: true,
              googlePay: true,
              merchantCountryCode: 'US',
              merchantDisplayName: 'saad',
              // style:  ThemeMode.dark,
            ),
          );
          setState(() {});
          displayPayment();
        } catch (error) {
          print('asfsaf');
          print(error);
        }
      }
      catch(error){
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
            confirmPayment: true),
      );
      setState(() {});
      CartProvider().clearcart();
      bool isPaymentStored =
          await Service().paymentStored((_paymentSheetData['amount'] / 100));
      if (isPaymentStored){
        //  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      // final user = firebaseAuth.currentUser;
       Navigator.pushReplacementNamed(context,AppRouter.paymentSuccess,arguments: {
                            'cartlist': widget.checkoutdata['cartlist'],
                            
                            // 'email': user.email,
                            'paymentid': _paymentSheetData['id'],
                            'orderid': '1201',
                            'amount': total,
                            'charges': widget.checkoutdata['charges'],
                            'shipping': widget.checkoutdata['shipping'],
                            'qty': totatqty,
                            'type': widget.checkoutdata['type']
                          });
        Toast.show('Payment Success', context, duration: 3);
      }
      
      else
        Toast.show('Failed', context, duration: 3);
    } catch (error) {
      print(error);
    }
  }

  List<Widget> renderAddList() {
    return List.generate(
        1,
        (index) => Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              widget.checkoutdata['type'] == 'cart'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            height: 40,
                                            // color: Colors.red,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.83,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Total Items',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'x ' +
                                                      widget
                                                          .checkoutdata[
                                                              'cartlist']
                                                          .length
                                                          .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                      ],
                                    )
                                  : Container(),
                              widget.checkoutdata['type'] == 'cart'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            height: 40,
                                            // color: Colors.red,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.83,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Total Items Quantity',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'x ' + totatqty.toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                      ],
                                    )
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
                                            margin: EdgeInsets.only(left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Lovesats Suscription',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // Text(
                                                //   ' ' + totatqty.toString(),
                                                //   maxLines: 2,
                                                //   overflow: TextOverflow.ellipsis,
                                                //   style: TextStyle(
                                                //       fontWeight: FontWeight.bold),
                                                // ),
                                              ],
                                            )),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.kFoodyBiteDarkBackground,
        elevation: 0.0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.secondaryElement,
          ),
        ),
        centerTitle: true,
        title: Text(
          StringConst.SUMMARY,
          style: Styles.customTitleTextStyle(
            color: AppColors.secondaryElement,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_20,
          ),
        ),
      ),
      bottomSheet: Container(
        height: 70,
        alignment: Alignment.topCenter,
        child: loader
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryElement),
                  ),
                ),
              )
            : PotbellyButton(StringConst.PAYNOW, buttonHeight: 50, onTap: () {
                paynow();
              }),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            children: [
              Column(
                children: renderAddList(),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal'),
                  Text('${StringConst.currency}' + widget.checkoutdata['total'].toStringAsFixed(2))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping'),
                  Text(
                      '${StringConst.currency}' + widget.checkoutdata['shipping'].toStringAsFixed(2))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Service Charges'),
                  Text('${StringConst.currency}' + widget.checkoutdata['charges'].toStringAsFixed(2))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(height: 3, color: AppColors.headingText),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${StringConst.currency}' + total.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addOrderItemsToServer() async {
    var orderItems = widget.checkoutdata['cartlist'];
    print('this is our ddata');
    print(orderItems);
    await Service().addOrderItems(orderItems);
    // orderItems.
    // var resID = orderItems['restaurantId'];
    // var price = orderItems['price'];
    // var productid = orderItems['id'];
  }
}
