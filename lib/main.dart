import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/splash_screen.dart';
import 'package:potbelly/theme.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51ISmUBHxiL0NyAbFEVjryq52Z9kzhSVCzWlz4dTKFFk8m36jvkHmcyhbFDFzJ1tjV7BtOGtcU56sG9uhosU3mz3e00MAu7hMUv';
  Stripe.merchantIdentifier = 'MerchantIdentifier';
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(context),
      initialRoute: AppRouter.splashScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorKey: AppRouter.navigator.key,
      home: SplashScreen(),
    );
  }
}
