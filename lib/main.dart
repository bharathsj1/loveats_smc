import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/New_splash_Screen.dart';
import 'package:potbelly/theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'grovey_startScreens/ProviderService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51ISmUBHxiL0NyAbFEVjryq52Z9kzhSVCzWlz4dTKFFk8m36jvkHmcyhbFDFzJ1tjV7BtOGtcU56sG9uhosU3mz3e00MAu7hMUv';
  Stripe.merchantIdentifier = 'MerchantIdentifier';
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderService()),
      ],
      child: Consumer<ProviderService>(
        builder: (context, appState, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(context),
      initialRoute: AppRouter.newsplashScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // navigatorKey: AppRouter.navigator.key,
      // home: SplashScreen(),
      home: New_Splash(),
  );
        }));
  }
}