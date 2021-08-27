import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' ;
import 'package:potbelly/Stripe_cards/loading_button.dart';
import 'package:potbelly/models/get_all_subscription_model.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/paymentservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/subscription_webview.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/toaster.dart';
import 'package:toast/toast.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  GetAllSubscriptionModel _getAllSubscriptionModel;
  SpecificUserSubscriptionModel _specificUserSubscriptionModel;
  var _paymentSheetData;
  bool _isLoading = true;
  TextStyle descriptionStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.black38,
  );
  @override
  void initState() {
    getSubscriptionPlans();
    // storesubs();
    // getSpecificUserSubscription();
    super.initState();
  }

  //   void getSpecificUserSubscription() async {
  //   _specificUserSubscriptionModel =
  //       await Service().getSpecificUserSubscriptionData();
  //   print(_specificUserSubscriptionModel.data);
 
  //   for (var i = 0; i < _getAllSubscriptionModel.data.length; i++) {
  //    var check= _specificUserSubscriptionModel.data
  //           .where((x) => x.id == _getAllSubscriptionModel.data[i].id && x.status== 'active')
  //           .toList();

  //           if(check.length >0){
  //             _getAllSubscriptionModel.data[i].active=false;
  //           }
  //   }
  //   _isLoading = false;
  //   setState(() {});
  // }

  CardFieldInputDetails _card;

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
                    'Available plans',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
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
                ),
              
              ],
            ),
      // body:   Column(
      //   children: [
      //     Padding(
      //       padding: EdgeInsets.all(16),
      //       child: CardField(
      //         // autofocus: true,
      //         cvcHintText: 'CVC',
      //         enablePostalCode: false,
      //         expirationHintText: 'MM/YY',
      //         numberHintText: '4242424242424242',
      //         postalCodeHintText: 'postal code',
      //         cursorColor: Colors.grey,
              
      //         onCardChanged: (card) {
      //           setState(() {
      //             _card = card;
      //           });
      //         },
      //       ),
      //     ),
      //     Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 16),
      //       child: LoadingButton(
      //         onPressed: _card?.complete == true ? _handlePayPress : null,
      //         text: 'Pay',
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  
  Future<void> _handlePayPress() async {
    if (_card == null) {
      return;
    }

    try {

    // 1. Gather customer billing information (ex. email)

    final billingDetails = BillingDetails(
      email: 'email@stripe.com',
      phone: '+48888000888',
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    ); // mocked data for tests

    // 2. Create payment method
    final paymentMethod =
        await Stripe.instance.createPaymentMethod(PaymentMethodParams.card());
    //   billingDetails: billingDetails,
    // ));
    // pm_1JTArvHxiL0NyAbFpH42h9yq
    print(paymentMethod);

    // 3. call API to create PaymentIntent
    // final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
    //   useStripeSdk: true,
    //   paymentMethodId: paymentMethod.id,
    //   currency: 'usd', // mocked data
    //   items: [
    //     {'id': 'id'}
    //   ],
    // );



    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')));
    }
  }


  Container buildCard(BuildContext context, int index) {
    var data = _getAllSubscriptionModel.data[index];
    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.name),
            Text(
              data.description ?? 'Not Available',
              style: descriptionStyle,
            ),
            const SizedBox(
              height: 20.0,
            ),
            PotbellyButton('Join now', onTap: () async {
              String userId = await Service().getUserId();
              print(userId);

              if (userId == null) {
                showToaster('Some Error Occured');
                return;
              }

              bool isDone = await checkAlreadyApplied(userId, data.id);
              if (isDone) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => SubscriptionWebview(
                //       planId: data.id,
                //       userId: userId,
                //       isrecipe: false,
                      
                //     ),
                //   ),
                // );
                 Navigator.pushNamed(context, AppRouter.testing,
                                    arguments: {
                                      'subscribe':true
                                    });
              } else {
                Toast.show(
                    'You are already subscribed for this package', context);
                return;
              }
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
    print(_getAllSubscriptionModel);
    // getSpecificUserSubscription();
    setState(() {});
  }

   storesubs() async {
     var data={
      //  'user_id':42,
       'payment_method_id':'pm_1JTArvHxiL0NyAbFpH42h9yq'
     };
    var response = await AppService().storesub(data);
    print(response);
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

  Future<bool> checkAlreadyApplied(userId, planId) async {
    bool isOk = await Service().checkAlreadyHaveSubscription(userId, planId);
    if (isOk == null) {
      Toast.show('SOme Error Occured', context);
    }
    return isOk;
  }
}
