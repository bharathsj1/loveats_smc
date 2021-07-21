import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:potbelly/models/get_all_subscription_model.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/paymentservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/subscription_webview.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:toast/toast.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  GetAllSubscriptionModel _getAllSubscriptionModel;
  var _paymentSheetData;
  bool _isLoading = true;
  @override
  void initState() {
    getSubscriptionPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  color: AppColors.secondaryElement,
                  child: Text(
                    'Choose Your Subscription',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _getAllSubscriptionModel.data.length,
                      itemBuilder: (context, index) {
                        return buildCard(
                          context,
                          index,
                        );
                      }),
                )
              ],
            ),
    );
  }

  Card buildCard(BuildContext context, int index) {
    var data = _getAllSubscriptionModel.data[index];
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.planDetails),
            Wrap(
              spacing: 10.0,
              children: [
                Chip(
                  label: Row(
                    children: [
                      Text('Price'),
                      Text(' \$ ${data.price}'),
                    ],
                  ),
                ),
                Chip(
                  label: Row(
                    children: [
                      Text('Discount'),
                      Text(' ${data.discount} %'),
                    ],
                  ),
                ),
                Chip(
                  label: Row(
                    children: [
                      Text('Duration'),
                      Text(' ${data.duration} Days'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            PotbellyButton('Subscribe', onTap: () async {
              var price = int.tryParse(data.price) -
                  (int.tryParse(data.price) *
                      (int.tryParse(data.discount)) /
                      100);
              var userId = await Service().getUserId();
            
             
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SubscriptionWebview(
                            planId: data.id.toString(),
                            userId: userId,
                          )));
              //   paynow(price.toStringAsFixed(0).toString());
            }),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  void getSubscriptionPlans() async {
    _getAllSubscriptionModel = await Service().getAllSubscription();
    _isLoading = false;
    setState(() {});
  }

  paynow(price) async {
    print(price);
    if (price == '0') {
      price = '1';
    }
    setState(() {});
    var data = {
      'amount': price + '00',
      'currency': 'usd',
      // 'receipt_email': 'miansaadhafeez@gmail.com'
    };
    PaymentService().getIntent(data).then((value) async {
      print(value);

      setState(() {});
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
      // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      // final user =  firebaseAuth.currentUser;
      Navigator.pushNamed(context, AppRouter.CheckOut3, arguments: {
        'type': 'subscription',
        // 'orderId': DateTime.now().millisecondsSinceEpoch
      });
      Toast.show('Payment Success', context, duration: 3);
      bool isSubscribed = await Service().subscribedOffer('1');
      if (isSubscribed)
        Navigator.pushNamed(context, AppRouter.CheckOut3, arguments: {
          'type': 'subscription',
          // 'orderId': DateTime.now().millisecondsSinceEpoch
        });
      else {}
    } catch (error) {
      print(error);
    }
  }
}
