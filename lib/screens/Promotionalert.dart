import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/paymentservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:toast/toast.dart';

final List<String> images = [
  'assets/images/main2.png',
  // 'assets/loginvideo2.gif',
  'assets/images/Slide1.jpg',
  'assets/images/Slide2.jpg',
  'assets/images/Slide3.jpg',
  'assets/images/Slide4.jpg',
];

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

final List child = map<Widget>(
  images,
  (index, i) {
    return Container(
      child: Image.asset(
        i,
        fit: BoxFit.cover,
        width: 1000,
      ),
    );
  },
).toList();

class PromotionPhotosScreen extends StatefulWidget {
  @override
  _PromotionPhotosScreenState createState() => _PromotionPhotosScreenState();
}

class _PromotionPhotosScreenState extends State<PromotionPhotosScreen> {
  int _current = 0;
  bool loader = false;
  var _paymentSheetData;

  paynow() async {
    this.loader = true;
    setState(() {});
    var data = {
      'amount': '1' + '00',
      'currency': 'usd',
      // 'receipt_email': 'miansaadhafeez@gmail.com'
    };
    PaymentService().getIntent(data).then((value) async {
      print(value);
      this.loader = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kFoodyBiteDarkBackground,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // SizedBox(
            //   height: 120,
            // ),
            Align(
              alignment: Alignment.center,
              child: CarouselSlider(
                  items: List.generate(
                      images.length,
                      (i) => Image.asset(
                            images[i],
                            fit: BoxFit.cover,
                            width: 1000,
                          )),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    reverse: false,
                    enableInfiniteScroll: false,
                    scrollPhysics: BouncingScrollPhysics(),
                    viewportFraction: 1.0,
                    onPageChanged: (index, reaseon) {
                      setState(() {
                        _current = index;
                      });
                    },
                  )),
            ),
            //  Padding(
            //    padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text(
            //         'Trying to Join Netflix?',
            //         style: TextStyle(
            //           fontSize: 40,
            //           fontWeight: FontWeight.bold,
            //           color: AppColors.white
            //         ),
            //       ),
            //       SizedBox(
            //         height: 15,
            //       ),
            //       Text(
            //         'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing. What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
            //         style: TextStyle(
            //           fontSize: 22,
            //           color: AppColors.secondaryElement,
            //           fontWeight: FontWeight.w500
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(
                    images,
                    (index, url) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? AppColors.secondaryElement
                              : AppColors.kFoodyBiteUnselectedSliderDot,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
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
                  : PotbellyButton(
                      StringConst.SUBSCRIPTION,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRouter.subscriptionPage);
                        //  var data={
                        //                 'cartlist': null,
                        //                 'charges':0.0,
                        //                 'shipping':0.0,
                        //                 'total': 1,
                        //                 'type': 'promo'
                        //               };
                        //           AppRouter.navigator.pushReplacementNamed(
                        //             AppRouter.checkoutScreen, arguments: data
                        //           );
                        //  paynow();
                      },
                    ),
            ),
            Positioned(
              top: 40,
              left: 15,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  ImagePath.closeIcon,
                  color: AppColors.primaryColor,
                  height: 15,
                  width: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
