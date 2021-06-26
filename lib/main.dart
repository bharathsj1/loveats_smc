import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    );
  }
}
